{
  lib,
  python3,
  buildEnv,
  writeText,
  runCommandCC,
  stdenv,
  runCommand,
  vapoursynth,
  makeWrapper,
  withPlugins,
}:

plugins:
let
  pythonEnvironment = python3.buildEnv.override { extraLibs = plugins; };

  getRecursivePropagatedBuildInputs =
    pkgs:
    lib.flatten (
      map (
        pkg:
        let
          cleanPropagatedBuildInputs = lib.filter lib.isDerivation pkg.propagatedBuildInputs;
        in
        cleanPropagatedBuildInputs ++ (getRecursivePropagatedBuildInputs cleanPropagatedBuildInputs)
      ) pkgs
    );

  deepPlugins = lib.unique (plugins ++ (getRecursivePropagatedBuildInputs plugins));

  pluginsEnv = buildEnv {
    name = "vapoursynth-plugins-env";
    pathsToLink = [ "/lib/vapoursynth" ];
    paths = deepPlugins;
  };

  pluginLoader =
    let
      source = writeText "vapoursynth-nix-plugins.cpp" ''
        #include <filesystem>

        struct VSCore;

        void VSLoadPluginsNix(void (*load)(VSCore *, const std::filesystem::path &), VSCore *core) {
        ${lib.concatMapStrings (
          path: ''load(core, std::filesystem::u8path("${path}/lib/vapoursynth"));''
        ) deepPlugins}
        }
      '';
    in
    runCommandCC "vapoursynth-plugin-loader"
      {
        executable = true;
        preferLocalBuild = true;
        allowSubstitutes = false;
      }
      ''
        mkdir -p $out/lib
        $CXX -std=c++17 -shared -fPIC ${source} -o "$out/lib/libvapoursynth-nix-plugins${ext}"
      '';

  ext = stdenv.hostPlatform.extensions.sharedLibrary;
in
runCommand "${vapoursynth.name}-with-plugins"
  {
    nativeBuildInputs = [ makeWrapper ];
    passthru = {
      inherit python3;
      inherit (vapoursynth) src version;
      withPlugins = plugins': withPlugins (plugins ++ plugins');
    };
  }
  ''
    mkdir -p \
      $out/bin \
      $out/lib/pkgconfig \
      $out/lib/vapoursynth \
      $out/${python3.sitePackages}

    for textFile in \
        lib/pkgconfig/vapoursynth{,-script}.pc \
        lib/libvapoursynth.la \
        lib/libvapoursynth-script.la \
        ${python3.sitePackages}/vapoursynth.la
    do
        substitute ${vapoursynth}/$textFile $out/$textFile \
            --replace "${vapoursynth}" "$out"
    done

    for binaryPlugin in ${pluginsEnv}/lib/vapoursynth/*; do
        ln -s $binaryPlugin $out/''${binaryPlugin#"${pluginsEnv}/"}
    done

    for pythonPlugin in ${pythonEnvironment}/${python3.sitePackages}/*; do
        ln -s $pythonPlugin $out/''${pythonPlugin#"${pythonEnvironment}/"}
    done

    for binaryFile in \
        lib/libvapoursynth${ext} \
        lib/libvapoursynth-script${ext}.0.0.0
    do
      old_rpath=$(patchelf --print-rpath ${vapoursynth}/$binaryFile)
      new_rpath="$old_rpath:$out/lib"
      patchelf \
          --set-rpath "$new_rpath" \
          --output $out/$binaryFile \
          ${vapoursynth}/$binaryFile
      patchelf \
          --add-needed libvapoursynth-nix-plugins${ext} \
          $out/$binaryFile
    done

    for binaryFile in \
        ${python3.sitePackages}/vapoursynth${ext} \
        bin/.vspipe-wrapped
    do
        old_rpath=$(patchelf --print-rpath ${vapoursynth}/$binaryFile)
        new_rpath="''${old_rpath//"${vapoursynth}"/"$out"}"
        patchelf \
            --set-rpath "$new_rpath" \
            --output $out/$binaryFile \
            ${vapoursynth}/$binaryFile
    done

    ln -s \
        ${pluginLoader}/lib/libvapoursynth-nix-plugins${ext} \
        $out/lib/libvapoursynth-nix-plugins${ext}
    ln -s ${vapoursynth}/include $out/include
    ln -s ${vapoursynth}/lib/vapoursynth/* $out/lib/vapoursynth
    ln -s \
        libvapoursynth-script${ext}.0.0.0 \
        $out/lib/libvapoursynth-script${ext}
    ln -s \
        libvapoursynth-script${ext}.0.0.0 \
        $out/lib/libvapoursynth-script${ext}.0

    makeWrapper $out/bin/.vspipe-wrapped $out/bin/vspipe \
        --prefix PYTHONPATH : $out/${python3.sitePackages}
  ''

{
  deployAndroidPackage,
  lib,
  stdenv,
  package,
  os,
  arch,
  autoPatchelfHook,
  makeWrapper,
  pkgs,
  pkgsi686Linux,
  postInstall,
  meta,
}:

deployAndroidPackage {
  name = "androidsdk-tools";
  inherit package os arch;
  nativeBuildInputs = [ makeWrapper ] ++ lib.optionals (os == "linux") [ autoPatchelfHook ];
  buildInputs = lib.optional (os == "linux") (
    (with pkgs; [
      glibc
      freetype
      fontconfig
      fontconfig.lib
      stdenv.cc.cc.libgcc or null # fix for https://github.com/NixOS/nixpkgs/issues/226357
      libx11
      libxrender
      libxext
    ])
    ++ lib.optionals (os == "linux" && stdenv.isx86_64) (
      with pkgsi686Linux;
      [
        glibc
        libx11
        libxrender
        libxext
        fontconfig.lib
        freetype
        zlib
      ]
    )
  );

  patchInstructions = ''
    ${lib.optionalString (os == "linux") ''
      # Auto patch all binaries
      autoPatchelf .
    ''}

    # Wrap all scripts that require JAVA_HOME
    for i in bin; do
      find $i -maxdepth 1 -type f -executable | while read program; do
        if grep -q "JAVA_HOME" $program; then
          wrapProgram $PWD/$program --prefix PATH : ${pkgs.jdk8}/bin
        fi
      done
    done

    # Wrap monitor script
    wrapProgram $PWD/monitor \
      --prefix PATH : ${pkgs.jdk8}/bin \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath (
          with pkgs;
          [
            libx11
            libxtst
          ]
        )
      }

    # Patch all script shebangs
    patchShebangs .

    cd $out/libexec/android-sdk
    ${postInstall}
  '';

  inherit meta;
}

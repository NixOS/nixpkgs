{
  lib,
  stdenv,
  fetchFromGitHub,
  erlang,
  cl,
  libGL,
  libGLU,
  runtimeShell,
  git,
  eigen,
  libigl,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "wings";
  version = "2.4.1";

  src = fetchFromGitHub {
    owner = "dgud";
    repo = "wings";
    tag = "v${version}";
    hash = "sha256-3ulWbAOtYujaymN50u7buvnBdtYMEAe8Ji3arvPUH/s=";
  };

  nativeBuildInputs = [ git ];
  buildInputs = [
    erlang
    cl
    libGL
    libGLU
    eigen
    libigl
    cl
  ];

  preBuildPhases = [ "setupDepsPhase" ];
  setupDepsPhase = ''
    mkdir -p _deps/eigen _deps/libigl
    ln -s ${eigen}/include/eigen3/* _deps/eigen/
    ln -s ${libigl}/include/* _deps/libigl/
    ln -s ${cl}/lib/erlang/lib/cl* _deps/cl
  '';

  postPatch = ''
    find . -type f -name "Makefile" -exec sed -i 's,-Werror ,,' {} \;
    sed -i 's,../../wings/,../,' icons/Makefile
    find plugins_src -mindepth 2 -type f -name "*.[eh]rl" -exec sed -i 's,wings/src/,../../src/,' {} \;
    find plugins_src -mindepth 2 -type f -name "*.[eh]rl" -exec sed -i 's,wings/e3d/,../../e3d/,' {} \;
    find plugins_src -mindepth 2 -type f -name "*.[eh]rl" -exec sed -i 's,wings/intl_tools/,../../intl_tools/,' {} \;
    find . -type f -name "*.[eh]rl" -exec sed -i 's,wings/src/,../src/,' {} \;
    find . -type f -name "*.[eh]rl" -exec sed -i 's,wings/e3d/,../e3d/,' {} \;
    find . -type f -name "*.[eh]rl" -exec sed -i 's,wings/intl_tools/,../intl_tools/,' {} \;
    echo "${version}" > version
  '';

  makeFlags = [
    "TYPE=opt"
    "WINGS_VSN=${version}"
  ];

  preBuild = ''
    mkdir -p priv
  '';

  buildPhase = ''
    runHook preBuild

    make TYPE=opt WINGS_VSN=${version}
    cd c_src
    make
    cd ..

    runHook postBuild
  '';

  postBuild = ''
    test -d ebin || exit 1
    test -d priv || exit 1
  '';

  # I did not test the *cl* part. I added the -pa just by imitation.
  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/lib/wings-${version}/ebin $out/lib/wings-${version}/priv
    cp -R ebin/* $out/lib/wings-${version}/ebin/
    cp -R textures shaders plugins $out/lib/wings-${version}/
    cp -R priv/* $out/lib/wings-${version}/priv/ || true
    if [ -d c_src ]; then
      find c_src -name "*.so" -exec cp {} $out/lib/wings-${version}/priv/ \;
    fi
    cat << EOF > $out/bin/wings
    #!${runtimeShell}
    ${erlang}/bin/erl \
      -pa $out/lib/wings-${version}/ebin -run wings_start start_halt "$@"
    EOF
    chmod +x $out/bin/wings

    runHook postInstall
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://www.wings3d.com/";
    description = "Subdivision modeler inspired by Nendo and Mirai from Izware";
    license = lib.licenses.tcltk;
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.linux;
    mainProgram = "wings";
  };
}

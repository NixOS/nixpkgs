{ lib, stdenv, mkDerivation, boost, fetchurl, cmake, runtimeShell
, pkg-config, alsa-lib, libjack2, libsndfile, llvmPackages, fftw
, curl, gcc, libXt, libyamlcpp, qtbase, qtdeclarative, qtmacextras, qtpositioning
, qtsvg, qttools, qtwebengine, readline, qtwebchannel, qtwebsockets
, useSCEL ? false, emacs, gitUpdater, supercollider-with-plugins
, supercolliderPlugins, writeText, runCommand
}:

mkDerivation rec {
  pname = "supercollider";
  version = "3.13.0";

  src = fetchurl {
    url = "https://github.com/supercollider/supercollider/releases/download/Version-${version}/SuperCollider-${version}-Source.tar.bz2";
    sha256 = "sha256-D8Xbpbrq43+Qaa0oiFqkBcaiUwnjiGy+ERvTt8BVMc4=";
  };

  patches = [
    # add support for SC_DATA_DIR and SC_PLUGIN_DIR env vars to override compile-time values
    ./supercollider-3.12.0-env-dirs.patch
  ];

  postPatch = ''
    substituteInPlace common/sc_popen.cpp --replace '/bin/sh' '${runtimeShell}'
  ''
  # `macdeployqt` installs `.dylib`s in `Frameworks` and modifies the binaries
  # to point to these, but we don't want this, so here we use this hacky patch
  # to skip the `macdeployqt` step.
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace editors/sc-ide/CMakeLists.txt --replace "if(APPLE OR WIN32)" "if(FALSE)"
  '';

  strictDeps = true;

  nativeBuildInputs = [ cmake pkg-config qttools ]
    ++ lib.optionals useSCEL [ emacs ];

  buildInputs = [ gcc libjack2 libsndfile fftw curl libXt qtbase qtwebengine qtwebsockets readline ]
    ++ lib.optional (!stdenv.hostPlatform.isDarwin) alsa-lib
    ++ lib.optionals (stdenv.hostPlatform.isDarwin) [ boost libyamlcpp llvmPackages.libcxx qtdeclarative qtmacextras qtpositioning qtsvg qtwebchannel ];

  hardeningDisable = [ "stackprotector" ];

  cmakeFlags = [
    "-DSC_WII=OFF"
    "-DSC_EL=${if useSCEL then "ON" else "OFF"}"
  ] ++ lib.optionals stdenv.isDarwin [
    "-DSYSTEM_BOOST=ON"
    "-DSYSTEM_YAMLCPP=ON"
  ];

  passthru = {
    updateScript = gitUpdater {
      url = "https://github.com/supercollider/supercollider.git";
      rev-prefix = "Version-";
      ignoredVersions = "rc|beta";
    };

    tests = {
      # test to make sure sclang runs and included plugins are successfully found
      sclang-sc3-plugins = let
        supercollider-with-test-plugins = supercollider-with-plugins.override {
          plugins = with supercolliderPlugins; [ sc3-plugins ];
        };
        testsc = writeText "test.sc" ''
          var err = 0;
          try {
          MdaPiano.name.postln;
          } {
          err = 1;
          };
          err.exit;
        '';
      in runCommand "sclang-sc3-plugins-test" { } ''
        timeout 60s env XDG_CONFIG_HOME="$(mktemp -d)" QT_QPA_PLATFORM=minimal ${supercollider-with-test-plugins}/bin/sclang ${testsc} >$out
      '';
    };
  };

  # The darwin target doesn't install headers by default.
  preConfigure = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/include
    cp -r include $out/include/SuperCollider
    cp SCVersion.txt $out/include/SuperCollider
  '';

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    # Move the `.app` into the conventional `Applications` directory.
    mkdir -p $out/Applications
    mkdir -p $out/share/SuperCollider
    mv $out/SuperCollider/SuperCollider.app $out/Applications
    mv $out/SuperCollider/examples $out/share/SuperCollider
    rm -r $out/SuperCollider

    # Make the plugins available under `lib` (where `SC_PLUGIN_DIR` expects them).
    mkdir -p $out/lib/SuperCollider/plugins
    ln -s $out/Applications/SuperCollider.app/Contents/Resources/plugins/* $out/lib/SuperCollider/plugins/

    # Expose the bins from the `.app`.
    mkdir -p $out/bin
    ln -s $out/Applications/SuperCollider.app/Contents/MacOS/sclang $out/bin/sclang
    ln -s $out/Applications/SuperCollider.app/Contents/MacOS/SuperCollider $out/bin/SuperCollider
    ln -s $out/Applications/SuperCollider.app/Contents/Resources/scsynth $out/bin/scsynth
  '';

  qtWrapperArgs = lib.optionals stdenv.hostPlatform.isDarwin [
    # Without this, supercollider runs into the following error, which is
    # odd as `resources/icudtl.dat` is provided by `qtwebengine`...
    # ```
    # [1205/215056.686545:ERROR:icu_util.cc(251)] Couldn't mmap icu data file
    # ```
    "--set QTWEBENGINE_DISABLE_SANDBOX 1"
  ];

  meta = with lib; {
    description = "Programming language for real time audio synthesis";
    homepage = "https://supercollider.github.io";
    changelog = "https://github.com/supercollider/supercollider/blob/Version-${version}/CHANGELOG.md";
    mainProgram = "SuperCollider";
    maintainers = with maintainers; [ mitchmindtree ];
    license = licenses.gpl3Plus;
    platforms = with platforms; darwin ++ linux;
  };
}

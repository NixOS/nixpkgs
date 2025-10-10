{
  lib,
  stdenv,
  fetchurl,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  cmake,
  sundials,
  lapack,
  attrs,
  lark,
  lxml,
  rpclib,
  msgpack,
  numpy,
  scipy,
  pytz,
  dask,
  requests,
  matplotlib,
  pyqtgraph,
  notebook,
  plotly,
  hatchling,
  pyside6,
  jinja2,
  flask,
  dash,
  dash-bootstrap-components,
  qt6,
  fmpy,
  runCommand,
  enableRemoting ? true,
  versionCheckHook,
  fmi-reference-fmus,
  replaceVars,
}:
buildPythonPackage rec {
  pname = "fmpy";
  version = "0.3.23";
  disabled = pythonOlder "3.10";
  pyproject = true;

  # Bumping version? Make sure to look through the commit history for
  # bumped native/build_cvode.py pins (see above).
  src = fetchFromGitHub {
    owner = "CATIA-Systems";
    repo = "FMPy";
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-4jBYOymurGCbjT0WQjIRNsztwOXBYVTGLdc4kNSTOZw=";
  };

  nativeBuildInputs = [
    cmake
  ];

  build-system = [
    hatchling
  ];

  dependencies = [
    pyqtgraph
    pyside6
    attrs
    lark
    lxml
    msgpack
    numpy
    scipy
    pytz
    dask
    requests
    matplotlib
    pyqtgraph
    notebook
    plotly
    rpclib
    fmpy.passthru.cvode
    pyside6
    jinja2
    flask
    dash
    dash-bootstrap-components
  ];

  dontUseCmakeConfigure = true;
  dontUseCmakeBuildDir = true;

  patches = [
    (replaceVars ./0001-gui-override-Qt6-libexec-path.patch {
      qt6libexec = "${qt6.qtbase}/libexec/";
    })
    (replaceVars ./0002-sundials-override-shared-object-paths.patch {
      inherit (fmpy.passthru) cvode;
    })
    # Upstream does not accept pull requests for unknown legal
    # reasons, see:
    # <https://github.com/CATIA-Systems/FMPy/blob/v0.3.23/docs/contributing.md?plain=1#L60-L63>.
    # Thus a fix is vendored here until patched by maintainer. C.f.
    # <https://github.com/CATIA-Systems/FMPy/pull/762>
    ./0003-remoting-client-create-lockfile-with-explicit-r-w.patch
  ];

  # Make forced includes of other systems' artifacts optional in order
  # to pass build (otherwise vendored upstream from CI)
  postPatch = ''
    sed --in-place 's/force-include/source/g' pyproject.toml
  '';

  # Don't run upstream build scripts as they are too specialized.
  # cvode is already built, so we only need to build native binaries.
  # We run these cmake builds and then run the standard
  # buildPythonPackage phases.
  preBuild = ''
    cmakeFlags="-S native/src -B native/src/build -D CVODE_INSTALL_DIR=${passthru.cvode}"
    cmakeConfigurePhase
    cmake --build native/src/build --config Release
  ''
  + lib.optionalString (enableRemoting && stdenv.hostPlatform.isLinux) ''
    # reimplementation of native/build_remoting.py
    cmakeFlags="-S native/remoting -B remoting/linux64 -D RPCLIB=${rpclib}"
    cmakeConfigurePhase
    cmake --build remoting/linux64 --config Release
  ''
  # C.f. upstream build-wheel CI job
  + ''
    python native/copy_sources.py

    # reimplementation of native/compile_resources.py
    pushd src/
    python -c "from fmpy.gui import compile_resources; compile_resources()"
    popd
  '';

  pythonImportsCheck = [
    "fmpy"
    "fmpy.cross_check"
    "fmpy.cswrapper"
    "fmpy.examples"
    "fmpy.fmucontainer"
    "fmpy.logging"
    "fmpy.gui"
    "fmpy.gui.generated"
    "fmpy.ssp"
    "fmpy.sundials"
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  passthru = {
    # From sundials, build only the CVODE solver. C.f.
    # src/native/build_cvode.py
    cvode =
      (sundials.overrideAttrs (prev: {
        # hash copied from native/build_cvode.py
        version = "5.3.0";
        src = fetchurl {
          url = "https://github.com/LLNL/sundials/releases/download/v5.3.0/sundials-5.3.0.tar.gz";
          sha256 = "88dff7e11a366853d8afd5de05bf197a8129a804d9d4461fb64297f1ef89bca7";
        };

        cmakeFlags =
          prev.cmakeFlags
          ++ lib.mapAttrsToList (option: enable: lib.cmakeBool option enable) {
            # only build the CVODE solver
            BUILD_CVODE = true;

            BUILD_CVODES = false;
            BUILD_ARKODE = false;
            BUILD_IDA = false;
            BUILD_IDAS = false;
            BUILD_KINSOL = false;
          };

        # FMPy searches for sundials without the "lib"-prefix; strip it
        # and symlink the so-files into existence.
        postFixup = ''
          pushd $out/lib
          for so in *.so; do
            ln --verbose --symbolic $so ''${so#lib}
          done
          popd
        '';
      })).override
        {
          lapackSupport = false;
          lapack.isILP64 = stdenv.hostPlatform.is64bit;
          blas = lapack;
          kluSupport = false;
        };

    # Simulate reference FMUs from
    # <https://github.com/modelica/Reference-FMUs>.
    #
    # Just check that the execution passes; don't verify any numerical
    # results, but save them in case of future or manual check use.
    tests.simulate-reference-fmus = runCommand "${pname}-simulate-reference-fmus" { } ''
      mkdir $out
      # NB(find ! -name): Clocks.fmu is marked TODO upstream and is of a
      # FMI type that FMPy doesn't support currently (ModelExchange)
      for fmu in $(find ${fmi-reference-fmus}/*.fmu ! -name "Clocks.fmu"); do
        name=$(basename $fmu)
        echo "--- START $name ---"
        ${fmpy}/bin/fmpy simulate $fmu \
          --fmi-logging \
          --output-file $out/$name.csv \
          | tee $out/$name.out
      done
    '';
  };

  meta = {
    # A logging.dylib is built but is not packaged correctly so as to
    # be found. C.f.
    # <https://logs.ofborg.org/?key=nixos/nixpkgs.397658&attempt_id=9d7cb742-db51-4d9e-99ca-49425d87d14d>
    broken = stdenv.hostPlatform.isDarwin;
    description = "Simulate Functional Mockup Units (FMUs) in Python";
    homepage = "https://github.com/CATIA-Systems/FMPy";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ tmplt ];
    # Supported platforms are not exhaustively and explicitly stated,
    # but inferred from the artifacts that are vendored in upstream CI
    # builds. C.f.
    # <https://github.com/CATIA-Systems/FMPy/blob/v0.3.23/pyproject.toml?plain=1#L71-L112>
    platforms = lib.platforms.x86_64 ++ [ "i686-windows" ];
  };
}

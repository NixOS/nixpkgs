{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, cvode
, cmake
, attrs
, lark-parser
, lxml
, rpclib
, msgpack
, numpy
, scipy
, pytz
, dask
, requests
, matplotlib
, pyqt5
, pyqtgraph
, notebook
, plotly
}:

buildPythonPackage rec {
  pname = "FMPy";
  version = "0.3.1";
  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "CATIA-Systems";
    repo = "FMPy";
    rev = "v${version}";
    sha256 = "0ig08323id84nd9y272hyccky33my2nlhl44m41fxnkrg6xq7z3m";
  };

  nativeBuildInputs = [ cmake pyqt5 ];

  propagatedBuildInputs = [
    attrs
    lark-parser
    lxml
    msgpack
    numpy
    scipy
    pytz
    dask
    requests
    matplotlib
    pyqt5
    pyqtgraph
    notebook
    plotly
    rpclib
    cvode
  ];

  dontUseCmakeConfigure = true;
  dontUseCmakeBuildDir = true;

  postPatch = ''
    substitute ${./libraries.py} ./fmpy/sundials/libraries.py \
        --subst-var-by cvode ${cvode}
  '';

  # Don't run upstream build scripts as they are too specialized.
  # And don't build sundials because it is already built.
  preBuild =
    let
      platform = if stdenv.isDarwin then "darwin" else "linux";
    in
    ''
      # Don't reproduce the full build_cvode.py, just two items:
      # 1. The cswrapper (Model Exchange -> Co-Simulation wrapper).
      cmakeFlags="-DCVODE_INSTALL_DIR=${cvode} -S cswrapper -B cswrapper/build"
      cmakeConfigurePhase
      cmake --build cswrapper/build --config Release

      # 2. fmpy logger.
      cmakeFlags="-S fmpy/logging -B fmpy/logging/build"
      cmakeConfigurePhase
      cmake --build fmpy/logging/build --config Release

      # The reproduction of build_fmucontainer.py:
      cmakeFlags="-S fmpy/fmucontainer -B fmpy/fmucontainer/${platform}"
      cmakeConfigurePhase
      cmake --build fmpy/fmucontainer/${platform} --config Release
    '' + lib.optionalString stdenv.isLinux ''
      # The reproduction of build_remoting.py
      cmakeFlags="-S remoting -B remoting/linux64 -D RPCLIB=${rpclib}"
      cmakeConfigurePhase
      cmake --build remoting/linux64 --config Release
    '';

  # Some of tests are supposed to be failing in upstream, so we don't use
  # them for package verification at the moment.
  doCheck = false;

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

  meta = with lib; {
    description = "A free Python library to simulate Functional Mock-up Units (FMUs)";
    homepage = "https://github.com/CATIA-Systems/FMPy";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ balodja ];
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
  };
}

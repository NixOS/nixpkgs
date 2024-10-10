{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  cflib,
  appdirs,
  pyzmq,
  pyqtgraph,
  pyyaml,
  numpy,
  vispy,
  pyserial,
  pyqt6,
  pyqt6-sip,
  qasync,
  packaging,
  qtm,
  xorg,
  wrapQtAppsHook,
  pythonRelaxDepsHook,
  qt5,
}:

buildPythonPackage rec {
  pname = "cfclient";
  version = "2023.6";
  format = "setuptools";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "bitcraze";
    repo = "crazyflie-clients-python";
    rev = version;
    hash = "sha256-QQuULICE/RjhZj3GGeFJ0hFrFJJ9FphQndeqWQCf59A=";
  };

  postPatch = ''
    echo '{"version": "${version}"}' > src/cfclient/version.json
  '';

  propagatedBuildInputs = [
    cflib
    appdirs
    pyzmq
    pyqtgraph
    pyyaml
    numpy
    vispy
    pyserial
    pyqt6
    pyqt6-sip
    qasync
    packaging
    qtm
    pyqtgraph
  ];

  buildInputs = [
    qt5.qtbase
    xorg.libXinerama
  ];

  nativeBuildInputs = [
    wrapQtAppsHook
    pythonRelaxDepsHook
  ];

  postFixup = ''
    wrapQtApp $out/bin/cfclient
  '';

  pythonRelaxDeps = true;

  dontWrapQtApps = true;

  pythonImportsCheck = [ "cfclient" ];

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/bitcraze/crazyflie-clients-python";
    description = "Host applications and library for Crazyflie written in Python";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [
      vbruegge
      stargate01
    ];
    mainProgram = "cfclient";
  };
}

{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, setuptools-scm
, pythonOlder
, sdcc
, nmigen
, fx2
, libusb1
, aiohttp
, pyvcd
, bitarray
, crcmod
, yosys
, icestorm
, nextpnr
}:

buildPythonPackage rec {
  pname = "glasgow";
  version = "unstable-2021-03-02";
  disabled = pythonOlder "3.7";
  # python software/setup.py --version
  realVersion = "0.1.dev1660+g${lib.substring 0 7 src.rev}";

  src = fetchFromGitHub {
    owner = "GlasgowEmbedded";
    repo = "glasgow";
    rev = "41c48bbcee284d024e4249a81419fbbae674cf40";
    sha256 = "1fg8ps228930d70bczwmcwnrd1gvm02a58mxbpn8pyakwbwwa6hq";
  };

  nativeBuildInputs = [ setuptools-scm sdcc ];

  propagatedBuildInputs = [
    setuptools
    nmigen
    fx2
    libusb1
    aiohttp
    pyvcd
    bitarray
    crcmod
  ];

  checkInputs = [ yosys icestorm nextpnr ];

  enableParallelBuilding = true;

  preBuild = ''
    make -C firmware LIBFX2=${fx2}/share/libfx2
    cp firmware/glasgow.ihex software/glasgow
    cd software
    export SETUPTOOLS_SCM_PRETEND_VERSION="${realVersion}"
  '';

  # installCheck tries to build_ext again
  doInstallCheck = false;

  checkPhase = ''
    python -W ignore::DeprecationWarning test.py
  '';

  makeWrapperArgs = [
    "--set" "YOSYS" "${yosys}/bin/yosys"
    "--set" "ICEPACK" "${icestorm}/bin/icepack"
    "--set" "NEXTPNR_ICE40" "${nextpnr}/bin/nextpnr-ice40"
  ];

  meta = with lib; {
    description = "Software for Glasgow, a digital interface multitool";
    homepage = "https://github.com/GlasgowEmbedded/Glasgow";
    license = licenses.bsd0;
    maintainers = with maintainers; [ emily ];
  };
}

{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, setuptools_scm
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
  version = "unstable-2020-02-08";
  # python software/setup.py --version
  realVersion = "0.1.dev1352+g${lib.substring 0 7 src.rev}";

  src = fetchFromGitHub {
    owner = "GlasgowEmbedded";
    repo = "glasgow";
    rev = "2a8bfc981b90ba5d86c310911dbd6ffe71acd498";
    sha256 = "01v5269bv09ggvmq6lqyhr5am51hzmwya1p5n62h84b7rdwd8q9m";
  };

  nativeBuildInputs = [ setuptools_scm sdcc ];

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
    homepage = https://github.com/GlasgowEmbedded/Glasgow;
    license = licenses.bsd0;
    maintainers = with maintainers; [ emily ];
  };
}

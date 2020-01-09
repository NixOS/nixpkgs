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
  version = "unstable-2019-10-16";
  # python software/setup.py --version
  realVersion = "0.1.dev1286+g${lib.substring 0 7 src.rev}";

  src = fetchFromGitHub {
    owner = "GlasgowEmbedded";
    repo = "glasgow";
    rev = "4f968dbe6cf4e9d8e2d0a5163d82e996c24d5e30";
    sha256 = "1b50n12dc0b3jmim5ywg7daq62k5j4wkgmwzk88ric5ri3b8dl2r";
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

  preBuild = ''
    make -C firmware LIBFX2=${fx2}/share/libfx2
    cp firmware/glasgow.ihex software/glasgow
    cd software
    export SETUPTOOLS_SCM_PRETEND_VERSION="${realVersion}"
  '';

  # installCheck tries to build_ext again
  doInstallCheck = false;

  checkPhase = ''
    python -m unittest discover
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

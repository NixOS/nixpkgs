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
  version = "unstable-2019-09-28";
  # python setup.py --version
  realVersion = "0.1.dev1234+g${lib.substring 0 7 src.rev}";

  src = fetchFromGitHub {
    owner = "GlasgowEmbedded";
    repo = "Glasgow";
    rev = "a1cc0333315847980806fd0330021c6de05c5395";
    sha256 = "0rdx7fymz828i73bc559sr67aikydz1m8s2a0i6c86gznh1s3cfk";
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

  meta = with lib; {
    description = "Software for Glasgow, a digital interface multitool";
    homepage = https://github.com/GlasgowEmbedded/Glasgow;
    license = licenses.bsd0;
    maintainers = with maintainers; [ emily ];
  };
}

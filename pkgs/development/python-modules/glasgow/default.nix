{ lib
, buildPythonPackage
, fetchFromGitHub
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
  version = "unstable-2019-08-31";
  realVersion = lib.substring 0 7 src.rev;

  src = fetchFromGitHub {
    owner = "GlasgowEmbedded";
    repo = "Glasgow";
    rev = "21641a13c6a0daaf8618aff3c5bfffcb26ef6cca";
    sha256 = "1dpm1jmm4fg8xf17s6h9g5sc09gq8b6xq955sv2x11nrbqf98l4v";
  };

  nativeBuildInputs = [ sdcc ];

  propagatedBuildInputs = [
    nmigen
    fx2
    libusb1
    aiohttp
    pyvcd
    bitarray
    crcmod
  ];

  postPatch = ''
    substituteInPlace software/setup.py \
      --replace 'versioneer.get_version()' '"${realVersion}"'
  '';

  preBuild = ''
    make -C firmware LIBFX2=${fx2}/share/libfx2
    cp firmware/glasgow.ihex software/glasgow
    cd software
  '';

  # a couple failing tests and also installCheck tries to build_ext again
  doInstallCheck = false;
  doCheck = false;

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

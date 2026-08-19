{
  lib,
  fetchFromGitHub,
  fetchpatch,
  python3Packages,
  wirelesstools,
  aircrack-ng,
  wireshark-cli,
  reaverwps-t6x,
  cowpatty,
  hashcat,
  hcxtools,
  hcxdumptool,
  which,
  bully,
  pixiewps,
  john,
  iw,
  macchanger,
}:

python3Packages.buildPythonApplication rec {
  pname = "wifite2";
  version = "2.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kimocoder";
    repo = "wifite2";
    rev = version;
    hash = "sha256-G2AKKZUDS2UQm95TEhGJIucyMRcm7oL0d3J8uduEQhw=";
  };

  build-system = with python3Packages; [ setuptools ];

  patches = [
    (fetchpatch {
      url = "https://salsa.debian.org/pkg-security-team/wifite/raw/debian/2.7.0-1/debian/patches/Disable-aircrack-failing-test.patch";
      hash = "sha256-BUAowBajfnZ1x6Z3Ce3L0rAERv7v/KrdHcdvKxTxSrM=";
    })
    (fetchpatch {
      url = "https://salsa.debian.org/pkg-security-team/wifite/raw/debian/2.7.0-1/debian/patches/Disable-two-failing-tests.patch";
      hash = "sha256-wCwfNkF/GvOU5FWPmQ3dJ4Txthz9T9TO2xhSL5vllQc=";
    })
    (fetchpatch {
      url = "https://salsa.debian.org/pkg-security-team/wifite/raw/debian/2.7.0-1/debian/patches/fix-for-new-which.patch";
      hash = "sha256-8xs+O2ILSRcvsw2pyx2gEBFHdduoI+xmUvDBchKz2Qs=";
    })
  ];

  dependencies = with python3Packages; [
    chardet
    scapy
  ];

  pythonRemoveDeps = [ "argparse" ];

  propagatedBuildInputs = [
    aircrack-ng
    wireshark-cli
    reaverwps-t6x
    cowpatty
    hashcat
    hcxtools
    hcxdumptool
    wirelesstools
    which
    bully
    pixiewps
    john
    iw
    macchanger
  ];

  nativeCheckInputs = propagatedBuildInputs ++ [ python3Packages.pytestCheckHook ];

  meta = {
    homepage = "https://github.com/kimocoder/wifite2";
    description = "Rewrite of the popular wireless network auditor, wifite";
    mainProgram = "wifite";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      lassulus
      danielfullmer
    ];
  };
}

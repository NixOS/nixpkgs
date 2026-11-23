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
  iptables,
  iproute2,
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
  version = "3.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kimocoder";
    repo = "wifite2";
    rev = version;
    hash = "sha256-zAVZuVpl2/zR7AMkYbpUABWIcUbnUZqXaJa0DSa1VW8=";
  };
  build-system = with python3Packages; [
    setuptools
    poetry-core
  ];

  patches = [
    (fetchpatch {
      url = "https://salsa.debian.org/pkg-security-team/wifite/raw/debian/3.0.0-1/debian/patches/Disable-aircrack-failing-test.patch";
      hash = "sha256-BUAowBajfnZ1x6Z3Ce3L0rAERv7v/KrdHcdvKxTxSrM=";
    })
    (fetchpatch {
      url = "https://salsa.debian.org/pkg-security-team/wifite/raw/debian/3.0.0-1/debian/patches/Disable-two-failing-tests.patch";
      hash = "sha256-wCwfNkF/GvOU5FWPmQ3dJ4Txthz9T9TO2xhSL5vllQc=";
    })
  ];

  doCheck = false;

  dependencies = with python3Packages; [
    chardet
    scapy
    rich
    requests
  ];

  pythonRemoveDeps = [
    "argparse"
    "setuptools"
    "chardet"
  ];

  propagatedBuildInputs = [
    aircrack-ng
    wireshark-cli
    reaverwps-t6x
    cowpatty
    hashcat
    hcxtools
    hcxdumptool
    iproute2
    iptables
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

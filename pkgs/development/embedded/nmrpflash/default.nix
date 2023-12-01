{ fetchFromGitHub
, lib
, libnl
, libpcap
, pkg-config
, stdenv
}:
stdenv.mkDerivation rec {
  pname = "nmrpflash";
  version = "0.9.22";

  src = fetchFromGitHub {
    owner  = "jclehner";
    repo   = "nmrpflash";
    rev    = "v${version}";
    sha256 = "sha256-gr/7tZYnuXFvfIUh2MmtgSbFoELTomQ4h05y/WFDhjo=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libnl libpcap ];

  PREFIX = "${placeholder "out"}";
  STANDALONE_VERSION = version;

  preInstall = ''
    mkdir -p $out/bin
  '';

  meta = with lib; {
    description = "Netgear Unbrick Utility";
    homepage = "https://github.com/jclehner/nmrpflash";
    license = licenses.gpl3;
    maintainers = with maintainers; [ dadada ];
    platforms = platforms.unix;
  };
}

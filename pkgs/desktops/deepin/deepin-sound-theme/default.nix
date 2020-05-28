{ stdenv
, fetchFromGitHub
, deepin
}:

stdenv.mkDerivation rec {
  pname = "deepin-sound-theme";
  version = "15.10.6";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = "deepin-sound-theme";
    rev = version;
    sha256 = "1rgcfnynwdwqjsms80yvyr7wcdfc0an05crlp01sncsz0v5bzw86";
  };

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  passthru.updateScript = deepin.updateScript { inherit pname version src; };

  meta = with stdenv.lib; {
    description = "Deepin sound theme";
    homepage = "https://github.com/linuxdeepin/deepin-sound-theme";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}

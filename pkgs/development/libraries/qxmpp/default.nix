{ mkDerivation, lib, fetchFromGitHub, cmake }:

mkDerivation rec {
  pname = "qxmpp";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "${pname}-project";
    repo = pname;
    rev = "v${version}";
    sha256 = "1r6b2hgqd5s8ikc1w6x1a9dih1jkd456s691yjqafsqigcji2bp3";
  };

  nativeBuildInputs = [
    cmake
  ];

  meta = with lib; {
    description = "Cross-platform C++ XMPP client and server library";
    homepage = "https://github.com/qxmpp-project/qxmpp";
    platforms = platforms.linux;
    license = with licenses; [ lgpl21Plus ];
    maintainers = with maintainers; [ ajs124 ];
  };
}

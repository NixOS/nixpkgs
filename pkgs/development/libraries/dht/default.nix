{ lib
, stdenv
, cmake
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "dht";
  version = "unstable-2020-12-27";

  src = fetchFromGitHub {
    owner = "transmission";
    repo = pname;
    rev = "80024e5be80a301a84cbd735744790147f8b67f4";
    sha256 = "1yjhkp13bwchl1b8ppqsrn1hs1jr2yry9sgppvl4c6k9sqmqrci3";
  };

  nativeBuildInputs = [
    cmake
  ];

  meta = with lib; {
    description = " BitTorrent DHT library ";
    homepage = "https://github.com/transmission/dht";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ maintainers.onny ];
  };
}

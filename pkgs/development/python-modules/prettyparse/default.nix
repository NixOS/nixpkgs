{ lib
, fetchFromGitHub
, buildPythonPackage
}:

buildPythonPackage rec {
  pname = "prettyparse";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "MatthewScholefield";
    repo = "prettyparse";
    rev = "v${version}";
    sha256 = "1608494w4vp7qvisif8yf4idvn8w82bjx14crgzaj1sm31a8scr8";
  };

  meta = with lib; {
    description = "A clean, simple way to create Python argument parsers";
    homepage = "https://github.com/MatthewScholefield/prettyparse";
    maintainers = with maintainers; [ timokau ];
    license = licenses.mit;
  };
}

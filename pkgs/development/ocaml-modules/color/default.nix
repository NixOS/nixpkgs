{
  lib,
  fetchFromGitHub,
  buildDunePackage,
  gg,
}:

buildDunePackage rec {
  pname = "color";
  version = "0.3.0";

  minimalOCamlVersion = "4.08";

  src = fetchFromGitHub {
    owner = "anuragsoni";
    repo = "color";
    tag = version;
    hash = "sha256-MuCzQsTOz31iQVrwg6WosWjj15730X6D1q6+eeApcmQ=";
  };

  propagatedBuildInputs = [
    gg
  ];

  meta = with lib; {
    description = "Converts between different color formats";
    license = licenses.mit;
    maintainers = with maintainers; [ fgaz ];
    homepage = "https://github.com/anuragsoni/color";
  };
}

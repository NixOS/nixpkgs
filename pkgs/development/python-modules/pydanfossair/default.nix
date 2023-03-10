{ lib
, buildPythonPackage
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "pydanfossair";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "JonasPed";
    repo = "pydanfoss-air";
    rev = "v${version}";
    sha256 = "sha256-WTRiEQbd3wwNAz1gk0rS3khy6lg61rcGZQTMlBc0uO8=";
  };

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "pydanfossair" ];

  meta = with lib; {
    description = "Python interface for Danfoss Air HRV systems";
    homepage = "https://github.com/JonasPed/pydanfoss-air";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}

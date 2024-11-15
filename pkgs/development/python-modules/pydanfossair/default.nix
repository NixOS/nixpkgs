{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
}:

buildPythonPackage rec {
  pname = "pydanfossair";
  version = "0.3.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "JonasPed";
    repo = "pydanfoss-air";
    rev = "v${version}";
    hash = "sha256-ZTairxQbvijNiSomDoeZtmL/Hn3ce1Z5TEOf+0C8cYg=";
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

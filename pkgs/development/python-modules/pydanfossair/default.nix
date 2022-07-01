{ lib
, buildPythonPackage
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "pydanfossair";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "JonasPed";
    repo = "pydanfoss-air";
    rev = "v${version}";
    sha256 = "0950skga7x930whdn9f765x7fi8g6rr3zh99zpzaj8avjdwf096b";
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

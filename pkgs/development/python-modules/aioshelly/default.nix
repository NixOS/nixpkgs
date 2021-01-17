{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, netifaces
}:

buildPythonPackage rec {
  pname = "aioshelly";
  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = pname;
    rev = version;
    sha256 = "0177psqfib70vcvf3cg8plbwrilh770cqg8b547icdh5lnqv70b1";
  };

  propagatedBuildInputs = [
    aiohttp
    netifaces
  ];

  # Project has no test
  doCheck = false;
  pythonImportsCheck = [ "aioshelly" ];

  meta = with lib; {
    description = "Python library to control Shelly";
    homepage = "https://github.com/home-assistant-libs/aioshelly";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}

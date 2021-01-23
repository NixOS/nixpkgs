{ lib
, buildPythonPackage
, fetchFromGitHub
, aiohttp
}:

buildPythonPackage rec {
  pname = "coronavirus";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "nabucasa";
    repo = pname;
    rev = version;
    sha256 = "0mx6ifp8irj3669c67hs9r79k8gar6j4aq7d4ji21pllyhyahdwm";
  };

  propagatedBuildInputs = [
    aiohttp
  ];

  # no tests are present
  doCheck = false;
  pythonImportsCheck = [ "coronavirus" ];

  meta = with lib; {
    description = "Python client for getting Corona virus info";
    homepage = "https://github.com/nabucasa/coronavirus";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}

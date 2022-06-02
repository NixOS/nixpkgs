{ lib
, attrs
, buildPythonPackage
, fetchFromGitHub
, httpx
, packaging
, xmltodict
}:

buildPythonPackage rec {
  pname = "axis";
  version = "44";

  src = fetchFromGitHub {
    owner = "Kane610";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-GC8GiDP/QHU+8swe60VFPRx8kSMMHuXjIPEKCja8HPE=";
  };

  propagatedBuildInputs = [
    attrs
    httpx
    packaging
    xmltodict
  ];

  # Tests requires a server on localhost
  doCheck = false;
  pythonImportsCheck = [ "axis" ];

  meta = with lib; {
    description = "Python library for communicating with devices from Axis Communications";
    homepage = "https://github.com/Kane610/axis";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}

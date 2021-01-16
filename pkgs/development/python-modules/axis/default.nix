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
  version = "42";

  src = fetchFromGitHub {
    owner = "Kane610";
    repo = pname;
    rev = "v${version}";
    sha256 = "1144zkgyf63qlw4dfn1zqcbgaksmxvjc4115jhzi98z0fkvlk34p";
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

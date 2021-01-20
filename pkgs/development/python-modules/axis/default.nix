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
  version = "43";

  src = fetchFromGitHub {
    owner = "Kane610";
    repo = pname;
    rev = "v${version}";
    sha256 = "1p9yfixsrkw7rxbvgybcb653rbqv0x18wzqkh620g193snm9sgm2";
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

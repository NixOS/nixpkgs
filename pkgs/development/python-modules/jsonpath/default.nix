{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "jsonpath";
  version = "0.82";

  src = fetchPypi {
    inherit pname version;
    sha256 = "46d3fd2016cd5b842283d547877a02c418a0fe9aa7a6b0ae344115a2c990fef4";
  };

  meta = with lib; {
    description = "An XPath for JSON";
    homepage = "https://github.com/json-path/JsonPath";
    license = licenses.mit;
    maintainers = [ maintainers.mic92 ];
  };
}

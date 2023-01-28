{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, nose
}:

buildPythonPackage rec {
  version = "2.0.4";
  pname = "python-json-logger";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-dk12IXX5n8xGML1IU7CWMqy2CmIkrLJ84IzXDwsbgb0=";
  };

  nativeCheckInputs = [ nose ];

  meta = with lib; {
    homepage = "https://github.com/madzak/python-json-logger";
    description = "A python library adding a json log formatter";
    license = licenses.bsdOriginal;
    maintainers = [ maintainers.costrouc ];
  };

}

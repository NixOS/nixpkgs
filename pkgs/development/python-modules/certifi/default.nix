{ lib
, fetchPypi
, buildPythonPackage
}:

buildPythonPackage rec {
  pname = "certifi";
  version = "2020.4.5.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5ad7e9a056d25ffa5082862e36f119f7f7cec6457fa07ee2f8c339814b80c9b1";
  };

  pythonImportsCheck = [ "certifi" ];

  dontUseSetuptoolsCheck = true;

  meta = {
    homepage = "https://certifi.io/";
    description = "Python package for providing Mozilla's CA Bundle";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ koral ];
  };
}

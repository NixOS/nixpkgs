{ buildPythonPackage
, fetchPypi
, lib
, pytestCheckHook
, six
}:

buildPythonPackage rec {
  pname = "nested-lookup";
  version = "0.2.25";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-b6gydIyQOB8ikdhQgJ4ySSUZ7l8lPWpay8Kdk37KAug=";
  };

  propagatedBuildInputs = [
    six
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "nested_lookup" ];

  meta = with lib; {
    description = "Python functions for working with deeply nested documents (lists and dicts)";
    homepage = "https://git.unturf.com/python/nested-lookup";
    license = licenses.publicDomain;
    maintainers = with maintainers; [ tboerger ];
  };
}

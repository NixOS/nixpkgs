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
    hash = "sha256-b6gydIyQOB8ikdhQgJ4ySSUZ7l8lPWpay8Kdk37KAug=";
  };

  propagatedBuildInputs = [
    six
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "nested_lookup" ];

  meta = with lib; {
    description = "Python functions for working with deeply nested documents (lists and dicts)";
    homepage = "https://github.com/russellballestrini/nested-lookup";
    license = licenses.publicDomain;
    maintainers = with maintainers; [ tboerger ];
  };
}

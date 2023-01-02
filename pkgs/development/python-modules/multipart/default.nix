{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "multipart";
  version = "0.2.4";

  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "06ba205360bc7096fefe618e4f1e9b2cdb890b4f2157053a81f386912a2522cb";
  };

  patches = [
    (fetchpatch {
      name = "dont-test-semicolon-separators-in-urlencoded-data.patch";
      url = "https://github.com/defnull/multipart/commit/4d4ac6b79c453918ebf40c690e8d57d982ee840b.patch";
      hash = "sha256-rMeMhQEhonWAHzy5M8Im5mL6km5a9O0CGVOV+T3UNqo=";
    })
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "multipart" ];

  meta = {
    description = "Parser for multipart/form-data";
    homepage = "https://github.com/defnull/multipart";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}

{ lib
, fetchPypi
, buildPythonPackage
, setuptools-scm
, six
, astroid
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "asttokens";
  version = "2.4.1";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-sDhpcYuppusCfhNL/fafOKI21oHIPBYNUQdorxElS6A=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    six
  ];

  nativeCheckInputs = [
    astroid
    pytestCheckHook
  ];

  disabledTests = [
    # Test is currently failing on Hydra, works locally
    "test_slices"
  ];

  pythonImportsCheck = [ "asttokens" ];

  meta = with lib; {
    homepage = "https://github.com/gristlabs/asttokens";
    description = "Annotate Python AST trees with source text and token information";
    license = licenses.asl20;
    maintainers = with maintainers; [ leenaars ];
  };
}

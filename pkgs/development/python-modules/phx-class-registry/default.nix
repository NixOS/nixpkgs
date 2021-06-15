{ lib, buildPythonPackage, fetchPypi, isPy27, pytestCheckHook }:

buildPythonPackage rec {
  pname = "phx-class-registry";
  version = "3.0.5";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "14iap8db2ldmnlf5kvxs52aps31rl98kpa5nq8wdm30a86n6457i";
  };

  checkInputs = [ pytestCheckHook ];

  disabledTests = [
    "test_branding"
    "test_happy_path"
    "test_len"
  ];

  meta = with lib; {
    description = "Registry pattern for Python classes, with setuptools entry points integration";
    homepage = "https://github.com/todofixthis/class-registry";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}

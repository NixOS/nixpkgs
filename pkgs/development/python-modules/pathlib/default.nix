{ lib
, buildPythonPackage
, fetchPypi
, unittestCheckHook
, pythonAtLeast
}:

buildPythonPackage rec {
  pname = "pathlib";
  version = "1.0.1";
  format = "setuptools";
  disabled = pythonAtLeast "3.4"; # Was added to std library in Python 3.4

  src = fetchPypi {
    inherit pname version;
    sha256 = "17zajiw4mjbkkv6ahp3xf025qglkj0805m9s41c45zryzj6p2h39";
  };

  nativeCheckInputs = [ unittestCheckHook ];

  meta = {
    description = "Object-oriented filesystem paths";
    homepage = "https://pathlib.readthedocs.org/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
  };
}

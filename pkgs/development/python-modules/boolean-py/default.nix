{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "boolean-py";
  version = "5.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "bastikr";
    repo = "boolean.py";
    tag = "v${version}";
    hash = "sha256-h5iHcdN77ZRGMJnSJLoYkRTY1TeJ3yQ1eF193HKsNqU=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "boolean" ];

  meta = {
    description = "Implements boolean algebra in one module";
    homepage = "https://github.com/bastikr/boolean.py";
    license = lib.licenses.bsd2;
    maintainers = [ ];
  };
}

{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "boolean-py";
  version = "5.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "bastikr";
    repo = "boolean.py";
    tag = "v${version}";
    hash = "sha256-h5iHcdN77ZRGMJnSJLoYkRTY1TeJ3yQ1eF193HKsNqU=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "boolean" ];

  meta = with lib; {
    description = "Implements boolean algebra in one module";
    homepage = "https://github.com/bastikr/boolean.py";
    license = licenses.bsd2;
    maintainers = [ ];
  };
}

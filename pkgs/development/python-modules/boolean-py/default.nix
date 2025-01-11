{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "boolean-py";
  version = "4.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "bastikr";
    repo = "boolean.py";
    rev = "v${version}";
    hash = "sha256-i6aNzGDhZip9YHXLiuh9crGm2qT2toBU2xze4PDLleg=";
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

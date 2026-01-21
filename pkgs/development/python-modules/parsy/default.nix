{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "parsy";
  version = "2.2";
  format = "setuptools";

  src = fetchFromGitHub {
    repo = "parsy";
    owner = "python-parsy";
    tag = "v${version}";
    hash = "sha256-EzIpKlT0Yvh0XWP6tb24tvuOe4BH8KuwJ5WCUzAM8mY=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "parsy" ];

  meta = {
    homepage = "https://github.com/python-parsy/parsy";
    description = "Easy-to-use parser combinators, for parsing in pure Python";
    changelog = "https://github.com/python-parsy/parsy/blob/${src.tag}/docs/history.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ milibopp ];
  };
}

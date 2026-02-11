{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "parsy";
  version = "2.1";
  format = "setuptools";

  src = fetchFromGitHub {
    repo = "parsy";
    owner = "python-parsy";
    tag = "v${version}";
    hash = "sha256-/Bu3xZUpXI4WiYJKKWTJTdSFq8pwC1PFDw0Kr8s3Fe8=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "parsy" ];

  meta = {
    homepage = "https://github.com/python-parsy/parsy";
    description = "Easy-to-use parser combinators, for parsing in pure Python";
    changelog = "https://github.com/python-parsy/parsy/blob/v${version}/docs/history.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ milibopp ];
  };
}

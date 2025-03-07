{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "backports-shutil-which";
  version = "3.5.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "minrk";
    repo = "backports.shutil_which";
    tag = version;
    hash = "sha256-smvBySS8Ek24y8X9DUGxF4AfJL2ZQ12xeDhEBsZRiP0=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "Backport of shutil.which from Python 3.3";
    homepage = "https://github.com/minrk/backports.shutil_which";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
  };
}

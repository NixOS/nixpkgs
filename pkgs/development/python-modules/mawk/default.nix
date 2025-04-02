{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  poetry-core,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "mawk";
  version = "0.1.4";
  pyproject = true;

  src = fetchFromGitHub {
    repo = "mawk";
    owner = "jhidding";
    tag = "v${version}";
    hash = "sha256-Z/kQ1h+uQWzO4FYJ7Lok9GiXgTHuoQq9icBevPmlVPM=";
  };

  build-system = [
    poetry-core
  ];

  pythonImportCheck = [ "mawk" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = src.meta // {
    description = "Python implementation of a line processor with Awk-like semanticsn";
    maintainers = with lib.maintainers; [ mgttlinger ];
    platforms = poetry-core.meta.platforms;
    license = lib.licenses.asl20;
  };
}

{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  six,
  lxml,
}:

buildPythonPackage rec {
  pname = "cmsis-svd";
  version = "0.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cmsis-svd";
    repo = "cmsis-svd";
    tag = "python-${version}";
    hash = "sha256-fx9eR9/Nw/oxPaP9rm1G6sjGI7iU4bhkmTS7f8i2RrQ=";
  };

  preBuild = ''
    cd python
  '';

  build-system = [ setuptools ];

  dependencies = [
    six
    lxml
  ];

  pythonImportsCheck = [
    "cmsis_svd"
    "cmsis_svd.parser"
  ];

  meta = {
    description = "CMSIS SVD parser";
    homepage = "https://github.com/cmsis-svd/cmsis-svd";
    changelog = "https://github.com/cmsis-svd/cmsis-svd/blob/${src.rev}/CHANGELOG";
    maintainers = [ lib.maintainers.dump_stack ];
    license = lib.licenses.asl20;
  };
}

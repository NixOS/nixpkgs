{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "excelrd";
  version = "3.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "thombashi";
    repo = "excelrd";
    tag = "v${version}";
    hash = "sha256-PqAzijzNzejyNoIVHKx0NUHwt6KRMIcRrNCvSimxBlQ=";
  };

  build-system = [ setuptools ];

  # excelrd has no required runtime dependencies

  pythonImportsCheck = [ "excelrd" ];

  meta = {
    description = "Fork of xlrd with support for .xlsb files";
    homepage = "https://github.com/thombashi/excelrd";
    changelog = "https://github.com/thombashi/excelrd/releases/tag/v${version}";
    license = lib.licenses.bsdOriginal;
    maintainers = with lib.maintainers; [ yajo ];
  };
}

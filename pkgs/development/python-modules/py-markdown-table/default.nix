{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  poetry-core,
}:

buildPythonPackage rec {
  pname = "py-markdown-table";
  version = "1.3.0";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "hvalev";
    repo = "py-markdown-table";
    tag = "v${version}";
    hash = "sha256-BZDyBDW6Ok9WUb5FEAevVqkYM1S12pvkUCGbZ0XxxV4=";
  };

  build-system = [ poetry-core ];

  meta = {
    description = "Tiny python library with zero dependencies which generates formatted multiline tables in markdown";
    homepage = "https://github.com/hvalev/py-markdown-table";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jmbaur ];
  };
}

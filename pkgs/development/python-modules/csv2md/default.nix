{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
}:

buildPythonPackage rec {
  pname = "csv2md";
  version = "1.5.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "lzakharov";
    repo = "csv2md";
    rev = "v${version}";
    hash = "sha256-xIcDBmLLB6cU5M05tOGRcwPmHCXRSXELv7TuaMEfVEg=";
  };

  pythonImportsCheck = [ "csv2md" ];

  meta = {
    description = "Command line tool for converting CSV files into Markdown tables";
    homepage = "https://github.com/lzakharov/csv2md";
    changelog = "https://github.com/lzakharov/csv2md/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ t4ccer ];
    mainProgram = "csv2md";
  };
}

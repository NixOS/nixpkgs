{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "csv2md";
  version = "1.7.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lzakharov";
    repo = "csv2md";
    rev = "v${finalAttrs.version}";
    hash = "sha256-UgX05ObIG3+Cucb0lC/+5w1WRB8eZbOeBpJoYHTotiw=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "csv2md" ];

  meta = {
    description = "Command line tool for converting CSV files into Markdown tables";
    homepage = "https://github.com/lzakharov/csv2md";
    changelog = "https://github.com/lzakharov/csv2md/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ t4ccer ];
    mainProgram = "csv2md";
  };
})

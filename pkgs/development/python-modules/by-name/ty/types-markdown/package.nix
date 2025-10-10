{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "types-markdown";
  version = "3.9.0.20250906";
  pyproject = true;

  src = fetchPypi {
    pname = "types_markdown";
    inherit version;
    hash = "sha256-8C3BotEwsJPeSRDGSy0KgRrnAg8DYk30HGZ4GNL+4FA=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "markdown-stubs" ];

  meta = with lib; {
    description = "Typing stubs for Markdown";
    homepage = "https://pypi.org/project/types-Markdown/";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}

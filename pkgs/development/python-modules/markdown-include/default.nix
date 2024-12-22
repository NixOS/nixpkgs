{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  markdown,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "markdown-include";
  version = "0.8.1";
  format = "setuptools";

  # only wheel on pypi
  src = fetchFromGitHub {
    owner = "cmacmackin";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-1MEk0U00a5cpVhqnDZkwBIk4NYgsRXTVsI/ANNQ/OH0=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [ markdown ];

  pythonImportsCheck = [ "markdown_include" ];

  doCheck = false; # no tests

  meta = with lib; {
    description = "Extension to Python-Markdown which provides an include function";
    homepage = "https://github.com/cmacmackin/markdown-include";
    license = licenses.gpl3Plus;
    maintainers = [ ];
  };
}

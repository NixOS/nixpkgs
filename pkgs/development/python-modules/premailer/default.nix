{
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  lxml,
  cssselect,
  cssutils,
  requests,
  cachetools,
  lib,
}:

buildPythonPackage {
  pname = "premailer";
  version = "3.10.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "peterbe";
    repo = "premailer";
    rev = "f4ded0b9701c4985e7ff5c5beda83324c264ea62";
    hash = "sha256-8ALdpR3aIDg0wP+JYCPY1f7mEJgdJm8xlLlgGpa0Sa4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    lxml
    cssselect
    cssutils
    requests
    cachetools
  ];

  pythonImportsCheck = [ "premailer" ];

  meta = {
    changelog = "https://github.com/peterbe/premailer/blob/master/CHANGES.rst";
    description = "Turns CSS blocks into style attributes";
    homepage = "https://github.com/peterbe/premailer";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.linsui ];
  };
}

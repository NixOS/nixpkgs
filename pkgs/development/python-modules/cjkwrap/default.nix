{
  lib,
  buildPythonPackage,
  fetchFromGitLab,
  setuptools,
}:

buildPythonPackage rec {
  pname = "cjkwrap";
  version = "2.2";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "fgallaire";
    repo = "cjkwrap";
    rev = "v${version}";
    hash = "sha256-0wTx3rnlUfQEE2/Z8Y7iwlsHk+CIy6ut+QIpC5yg4aM=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "cjkwrap" ];

  # no tests
  doCheck = false;

  meta = {
    description = "Library for wrapping and filling CJK text";
    homepage = "https://f.gallai.re/cjkwrap";
    license = lib.licenses.lgpl3Plus;
    maintainers = [ lib.maintainers.kaction ];
  };
}

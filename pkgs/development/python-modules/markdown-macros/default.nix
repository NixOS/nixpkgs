{
  lib,
  buildPythonPackage,
  fetchPypi,
  fetchpatch,
  setuptools,
  markdown,
}:

buildPythonPackage rec {
  pname = "markdown-macros";
  version = "0.1.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-m6tlxZqMZGEpB3wnIfFXEzpwE8NYLBXE9UJEZs/K+9M=";
  };

  patches = [
    # Fixes a bug with markdown>2.4
    # https://github.com/wnielson/markdown-macros/pull/1
    (fetchpatch {
      name = "wnielson-markdown-macros-pull-1.patch";
      url = "https://github.com/wnielson/markdown-macros/commit/e38cba9acb6789cc128f6fe9ca427ba71815a20f.patch";
      hash = "sha256-ILLua0UdwOaSKLGxQt5QbWmbnUjWm6wGcPNnLfBb0p4=";
    })
  ];

  prePatch = ''
    substituteInPlace setup.py --replace-fail "distribute" "setuptools"
  '';

  build-system = [ setuptools ];

  dependencies = [ markdown ];

  doCheck = false;

  meta = {
    description = "Extension for python-markdown that makes writing trac-like macros easy";
    homepage = "https://github.com/wnielson/markdown-macros";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.abigailbuccaneer ];
  };
}

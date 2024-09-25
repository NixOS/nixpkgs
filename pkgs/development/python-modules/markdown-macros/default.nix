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
    sha256 = "1lzvrb7nci22yp21ab2qqc9p0fhkazqj29vw0wln2r4ckb2nbawv";
  };

  patches = [
    # Fixes a bug with markdown>2.4
    # https://github.com/wnielson/markdown-macros/pull/1
    (fetchpatch {
      name = "wnielson-markdown-macros-pull-1.patch";
      url = "https://github.com/wnielson/markdown-macros/commit/e38cba9acb6789cc128f6fe9ca427ba71815a20f.patch";
      sha256 = "17njbgq2srzkf03ar6yn92frnsbda3g45cdi529fdh0x8mmyxci0";
    })
  ];

  prePatch = ''
    substituteInPlace setup.py --replace-fail "distribute" "setuptools"
  '';

  build-system = [ setuptools ];

  dependencies = [ markdown ];

  doCheck = false;

  meta = with lib; {
    description = "Extension for python-markdown that makes writing trac-like macros easy";
    homepage = "https://github.com/wnielson/markdown-macros";
    license = licenses.mit;
    maintainers = [ maintainers.abigailbuccaneer ];
  };
}

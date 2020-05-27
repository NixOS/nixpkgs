{ stdenv
, buildPythonPackage
, fetchPypi
, fetchpatch
, markdown
}:

buildPythonPackage rec {
  pname = "markdown-macros";
  version = "0.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1lzvrb7nci22yp21ab2qqc9p0fhkazqj29vw0wln2r4ckb2nbawv";
  };

  patches = [
    # Fixes a bug with markdown>2.4
    (fetchpatch {
      url = "https://github.com/wnielson/markdown-macros/pull/1.patch";
      sha256 = "17njbgq2srzkf03ar6yn92frnsbda3g45cdi529fdh0x8mmyxci0";
    })
  ];

  prePatch = ''
    substituteInPlace setup.py --replace "distribute" "setuptools"
  '';

  propagatedBuildInputs = [ markdown ];

  doCheck = false;

  meta = with stdenv.lib; {
    description = "An extension for python-markdown that makes writing trac-like macros easy";
    homepage = "https://github.com/wnielson/markdown-macros";
    license = licenses.mit;
    maintainers = [ maintainers.abigailbuccaneer ];
  };

}

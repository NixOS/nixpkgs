{ lib, fetchPypi, fetchpatch, buildPythonPackage,
  setuptools-scm, toml, six, astroid, pytest
}:

buildPythonPackage rec {
  pname = "asttokens";
  version = "2.0.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0a2ixiz04aw4p0aivxh47k3fa9ql804l3y5iv5gcih9aizi5fbm4";
  };

  patches = [
    # Fixes compatibility with python 3.9, will be included in the next release
    # after 2.0.4
    (fetchpatch {
      url = "https://github.com/gristlabs/asttokens/commit/d8ff80ee7d2e64c5e1daf50cc38eb99663f1b1ac.patch";
      sha256 = "19y8n8vpzr2ijldbq5rh19sf0vz5azqqpkb9bx0ljjg98h6k7kjj";
      excludes = [ "setup.cfg" ];
    })
  ];

  propagatedBuildInputs = [ setuptools-scm toml six astroid ];

  checkInputs = [ pytest ];

  meta = with lib; {
    homepage = "https://github.com/gristlabs/asttokens";
    description = "Annotate Python AST trees with source text and token information";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ leenaars ];
  };
}

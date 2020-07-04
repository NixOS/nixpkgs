{ lib, fetchPypi, buildPythonPackage,
  setuptools_scm, toml, six, astroid, pytest
}:

buildPythonPackage rec {
  pname = "asttokens";
  version = "2.0.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0a2ixiz04aw4p0aivxh47k3fa9ql804l3y5iv5gcih9aizi5fbm4";
  };

  propagatedBuildInputs = [ setuptools_scm toml six astroid ];

  checkInputs = [ pytest ];

  meta = with lib; {
    homepage = "https://github.com/gristlabs/asttokens";
    description = "Annotate Python AST trees with source text and token information";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ leenaars ];
  };
}

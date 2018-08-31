{ buildPythonPackage, fetchPypi, lib, pytest }:

buildPythonPackage rec {
  pname = "ordered-set";
  version = "3.0.1";

  buildInputs = [ pytest ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "0yyfkkfzpwlx4jlfqzb7p1xpzmn2jyzq2qlakqx62pxizfzxfvrx";
  };

  checkPhase = ''
    py.test test.py
  '';

  meta = {
    description = "A MutableSet that remembers its order, so that every entry has an index.";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.MostAwesomeDude ];
  };
}




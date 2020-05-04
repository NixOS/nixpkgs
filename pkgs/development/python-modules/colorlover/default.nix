{ buildPythonPackage, fetchPypi, stdenv
}:

buildPythonPackage rec {
  pname = "colorlover";
  version = "0.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b8fb7246ab46e1f5e6715649453c1762e245a515de5ff2d2b4aab7a6e67fa4e2";
  };

  # no tests included in distributed archive
  doCheck = false;

  meta = {
    homepage = "https://github.com/jackparmer/colorlover";
    description = "Color scales in Python for humans";
    license = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ globin ];
  };
}

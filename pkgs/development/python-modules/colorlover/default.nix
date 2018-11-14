{ buildPythonPackage, fetchPypi, stdenv
}:

buildPythonPackage rec {
  pname = "colorlover";
  version = "0.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1clwvssrj007r07prfvkqnpjy3f77dlp584lj879x8mwl8f0japi";
  };

  # no tests included in distributed archive
  doCheck = false;

  meta = {
    homepage = https://github.com/jackparmer/colorlover;
    description = "Color scales in Python for humans";
    license = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ globin ];
  };
}

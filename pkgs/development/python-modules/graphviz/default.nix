{ stdenv
, buildPythonPackage
, fetchPypi
, pkgs
}:

buildPythonPackage rec {
  pname = "graphviz";
  version = "0.9";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "14r9brj4r31b3qy1nnn34v3l4h0n39bqxg9sn2fz4p3pp5mglnl6";
  };

  propagatedBuildInputs = [ pkgs.graphviz ];

  meta = with stdenv.lib; {
    description = "Simple Python interface for Graphviz";
    homepage = https://github.com/xflr6/graphviz;
    license = licenses.mit;
  };

}

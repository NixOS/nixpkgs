{ stdenv
, buildPythonPackage
, fetchPypi
, pbr
, isPy3k
}:

buildPythonPackage rec {
  pname = "sandboxlib";
  version = "0.31";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0csj8hbpylqdkxcpqkcfs73dfvdqkyj23axi8m9drqdi4dhxb41h";
  };

  buildInputs = [ pbr ];

  meta = with stdenv.lib; {
    description = "Sandboxing Library for Python";
    homepage = https://pypi.python.org/pypi/sandboxlib/0.3.1;
    license = licenses.gpl2;
  };

}

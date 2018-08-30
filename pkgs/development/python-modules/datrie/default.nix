{ stdenv, buildPythonPackage, fetchPypi
, pytest, pytestrunner, hypothesis}:

buildPythonPackage rec {
  pname = "datrie";
  version = "0.7.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "08r0if7dry2q7p34gf7ffyrlnf4bdvnprxgydlfxgfnvq8f3f4bs";
  };

  buildInputs = [ pytest pytestrunner hypothesis ];

  meta = with stdenv.lib; {
    description = "Super-fast, efficiently stored Trie for Python";
    homepage = "https://github.com/kmike/datrie";
    license = licenses.lgpl2;
    maintainers = with maintainers; [ lewo ];
  };
}

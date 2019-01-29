{ stdenv, buildPythonPackage, fetchPypi
, cython, pytest, pytestrunner, hypothesis }:

buildPythonPackage rec {
  pname = "datrie";
  version = "0.7.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "08r0if7dry2q7p34gf7ffyrlnf4bdvnprxgydlfxgfnvq8f3f4bs";
  };

  nativeBuildInputs = [ cython ];
  buildInputs = [ pytest pytestrunner hypothesis ];

  # recompile pxd and pyx for python37
  # https://github.com/pytries/datrie/issues/52
  preBuild = ''
    ./update_c.sh
  '';

  meta = with stdenv.lib; {
    description = "Super-fast, efficiently stored Trie for Python";
    homepage = "https://github.com/kmike/datrie";
    license = licenses.lgpl2;
    maintainers = with maintainers; [ lewo ];
  };
}

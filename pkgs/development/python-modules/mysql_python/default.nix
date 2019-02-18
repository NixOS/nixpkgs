{ stdenv
, buildPythonPackage
, isPy3k
, fetchPypi
, nose
, pkgs
}:

buildPythonPackage rec {
  pname = "MySQL-python";
  version = "1.2.5";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "0x0c2jg0bb3pp84njaqiic050qkyd7ymwhfvhipnimg58yv40441";
  };

  buildInputs = [ nose ];
  propagatedBuildInputs = [ pkgs.mysql.connector-c ];

  # plenty of failing tests
  doCheck = false;

  meta = with stdenv.lib; {
    description = "MySQL database binding for Python";
    homepage = https://sourceforge.net/projects/mysql-python;
    license = licenses.gpl3;
  };

}

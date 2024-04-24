{ lib
, buildPythonPackage
, fetchPypi
, cryptography
}:

buildPythonPackage rec {
  pname = "pymysql";
  version = "1.0.2";

  src = fetchPypi {
    pname = "PyMySQL";
    inherit version;
    sha256 = "816927a350f38d56072aeca5dfb10221fe1dc653745853d30a216637f5d7ad36";
  };

  propagatedBuildInputs = [ cryptography ];

  # Wants to connect to MySQL
  doCheck = false;

  meta = with lib; {
    description = "Pure Python MySQL Client";
    homepage = "https://github.com/PyMySQL/PyMySQL";
    license = licenses.mit;
    maintainers = [ maintainers.kalbasit ];
  };
}

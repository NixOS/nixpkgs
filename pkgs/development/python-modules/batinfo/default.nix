{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "batinfo";
  version = "0.4.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "497e29efc9353ec52e71d43bd040bdfb6d685137ddc2b9143cded4583af572f5";
  };

  # No tests included
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/nicolargo/batinfo";
    description = "A simple Python lib to retrieve battery information";
    license = licenses.lgpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ koral ];
  };
}

{ lib
, buildPythonPackage
, fetchPypi
, cryptography
}:

buildPythonPackage rec {
  pname = "PyMySQL";
  version = "0.10.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0dwqw556qmjl5359wsylnh5kmw3ns8qkw1pn1gwf0l70hjy70h71";
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

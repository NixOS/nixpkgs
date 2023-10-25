{ lib
, buildPythonPackage
, fetchPypi
, colander
, sqlalchemy
}:

buildPythonPackage rec {
  pname = "colanderclchemy";
  version = "0.3.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "006wcfch2skwvma9bq3l06dyjnz309pa75h1rviq7i4pd9g463bl";
  };

  propagatedBuildInputs = [ colander sqlalchemy ];

  # Tests are not included in Pypi
  doCheck = false;

  meta = with lib; {
    description = "Autogenerate Colander schemas based on SQLAlchemy models";
    homepage = "https://github.com/stefanofontanelli/ColanderAlchemy";
    license = licenses.mit;
  };
}

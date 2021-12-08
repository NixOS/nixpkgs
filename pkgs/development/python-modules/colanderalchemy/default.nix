{ lib
, buildPythonPackage
, fetchFromGitHub
, colander
, sqlalchemy
}:

buildPythonPackage rec {
  pname = "ColanderAlchemy";
  version = "0.3.4";

  src = fetchFromGitHub {
     owner = "stefanofontanelli";
     repo = "ColanderAlchemy";
     rev = "v0.3.4";
     sha256 = "1j4c7lrra0cywj4zsx1z8yjldn63x8diwz6jjid8vq502smyz4ym";
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

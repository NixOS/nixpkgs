{
  lib,
  buildPythonPackage,
  fetchPypi,
  colander,
  sqlalchemy,
}:

buildPythonPackage rec {
<<<<<<< HEAD
  pname = "colanderalchemy";
=======
  pname = "colanderclchemy";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  version = "0.3.4";
  format = "setuptools";

  src = fetchPypi {
<<<<<<< HEAD
    inherit version;
    pname = "ColanderAlchemy";
=======
    inherit pname version;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    sha256 = "006wcfch2skwvma9bq3l06dyjnz309pa75h1rviq7i4pd9g463bl";
  };

  propagatedBuildInputs = [
    colander
    sqlalchemy
  ];

  # Tests are not included in Pypi
  doCheck = false;

<<<<<<< HEAD
  meta = {
    description = "Autogenerate Colander schemas based on SQLAlchemy models";
    homepage = "https://github.com/stefanofontanelli/ColanderAlchemy";
    license = lib.licenses.mit;
=======
  meta = with lib; {
    description = "Autogenerate Colander schemas based on SQLAlchemy models";
    homepage = "https://github.com/stefanofontanelli/ColanderAlchemy";
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}

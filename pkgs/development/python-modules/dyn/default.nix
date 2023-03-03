{ lib, buildPythonPackage, fetchPypi, pytest, pytest-cov, mock
, pytest-xdist, covCore, glibcLocales }:

buildPythonPackage rec {
  pname = "dyn";
  version = "1.8.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e112149d48b4500c18b3cfb6e0e6e780bb5aa0e56ff87cac412280200b9ec8bf";
  };

  buildInputs = [ glibcLocales ];

  nativeCheckInputs = [
    pytest
    pytest-cov
    mock
    pytest-xdist
    covCore
  ];
  # Disable checks because they are not stateless and require internet access.
  doCheck = false;

  LC_ALL="en_US.UTF-8";

  meta = with lib; {
    description = "Dynect dns lib";
    homepage = "https://dyn.readthedocs.org/en/latest/intro.html";
    license = licenses.bsd3;
  };
}

{ lib, buildPythonPackage, fetchPypi, pytest, pytest-cov, mock
, pytest-xdist, covCore, glibcLocales }:

buildPythonPackage rec {
  pname = "dyn";
  version = "1.8.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-933etYrKRgSqJfOMIuIDL4Uv4/RdSEFMNWFtW5qiPpA=";
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

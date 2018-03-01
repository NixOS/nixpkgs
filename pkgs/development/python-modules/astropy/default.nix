{ lib
, fetchPypi
, buildPythonPackage
, cython
, jinja2
, numpy
, sphinx
, pytest
, pytest-doctestplus
, pytest-remotedata
, pytest-openfiles
, pytest-arraydiff
}:

let
  # This meta-package is only used to pull in the test dependencies for astropy
  pytest-astropy = buildPythonPackage rec {
    pname = "pytest-astropy";
    version = "0.2.1";

    src = fetchPypi {
      inherit pname version;
      sha256 = "ced990fe65145ba87a9d0ce16b9d0c162f0c339b47c04d51f54aa382acb55425";
    };

    propagatedBuildInputs = [ pytest pytest-doctestplus pytest-remotedata pytest-openfiles pytest-arraydiff ]; 
  };

in buildPythonPackage rec {
  pname = "astropy";
  version = "3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9e0ad19b9d6d227bdf0932bbe64a8c5dd4a47d4ec078586cf24bf9f0c61d9ecf";
  };

  buildInputs = [ cython jinja2 ];

  # FIXME: astropy tries to download astropy-helpers using pip
  propagatedBuildInputs = [ numpy ];

  checkInputs = [ pytest-astropy ];

  checkPhase = ''
    pytest --open-files
  '';

  meta = {
    description = "Astronomy/Astrophysics library for Python";
    homepage = http://www.astropy.org;
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ kentjames ];
  };
}

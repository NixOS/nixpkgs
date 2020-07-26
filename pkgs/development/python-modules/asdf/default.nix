{ lib
, buildPythonPackage
, fetchPypi
, pytest-astropy
, semantic-version
, pyyaml
, jsonschema
, six
, numpy
, isPy27
, astropy
, setuptools_scm
, setuptools
}:

buildPythonPackage rec {
  pname = "asdf";
  version = "2.7.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1l0miw9py311sgz0yr010b0mrznlmy6lb25ikrv3nrnv34gp8zb8";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "semantic_version>=2.3.1,<=2.7.0" "semantic_version>=2.3.1" \
      --replace "doctest_plus = enabled" ""
  '';

  checkInputs = [
    pytest-astropy
    astropy
  ];

  propagatedBuildInputs = [
    semantic-version
    pyyaml
    jsonschema
    six
    numpy
    setuptools_scm
    setuptools
  ];

  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    description = "Python tools to handle ASDF files";
    homepage = "https://github.com/spacetelescope/asdf";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}

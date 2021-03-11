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
  version = "2.7.1";
  disabled = isPy27;
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4ba2e31cb24b974a10dfae3edee23db2e6bea2d00608604d062366aa3af6e81a";
  };

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
    PY_IGNORE_IMPORTMISMATCH=1 pytest
  '';

  meta = with lib; {
    description = "Python tools to handle ASDF files";
    homepage = "https://github.com/spacetelescope/asdf";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
    # many ValueError in tests
    broken = true;
  };
}

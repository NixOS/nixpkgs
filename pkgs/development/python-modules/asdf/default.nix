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
  version = "2.5.2";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ai5l62ldaq1cqfmq3hvnzp8gp0hjjmjnck9d3cnx5r8la5ig18y";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "semantic_version>=2.3.1,<=2.6.0" "semantic_version>=2.3.1" \
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

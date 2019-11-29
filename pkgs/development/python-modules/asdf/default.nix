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
  version = "2.4.2";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1wlgx8469wwsczc2gjka9k1a03yzird67zg3va0kg8y6j1qmbwvg";
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
    homepage = https://github.com/spacetelescope/asdf;
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}

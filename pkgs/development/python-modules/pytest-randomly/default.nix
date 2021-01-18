{ lib, buildPythonPackage, fetchPypi, isPy27
, factory_boy, faker, numpy
, pytest, pytest_xdist
}:

buildPythonPackage rec {
  pname = "pytest-randomly";
  version = "3.5.0";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "440cec143fd9b0adeb072006c71e0294402a2bc2ccd08079c2341087ba4cf2d1";
  };

  propagatedBuildInputs = [ numpy factory_boy faker ];

  checkInputs = [ pytest pytest_xdist ];

  # test warnings are fixed on an unreleased version:
  # https://github.com/pytest-dev/pytest-randomly/pull/281
  checkPhase = "pytest -p no:randomly";

  meta = with lib; {
    description = "Pytest plugin to randomly order tests and control random.seed";
    homepage = "https://github.com/pytest-dev/pytest-randomly";
    license = licenses.bsd3;
    maintainers = [ maintainers.sternenseemann ];
  };
}

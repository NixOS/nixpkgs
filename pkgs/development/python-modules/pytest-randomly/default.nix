{ lib, buildPythonPackage, fetchPypi, isPy27
, factory_boy, faker, numpy
, pytest, pytest_xdist
}:

buildPythonPackage rec {
  pname = "pytest-randomly";
  version = "3.4.1";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0s9cx692cdchfrjqx7fgf9wnm3fdac211a4hjq1cx9qqnbpdpl2z";
  };

  requiredPythonModules = [ numpy factory_boy faker ];

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

{ lib
, buildPythonPackage
, fetchPypi
, pytest
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pytest-check";
  version = "1.0.1";

  src = fetchPypi {
    pname = "pytest_check";
    inherit version;
    sha256 = "1i01i5ab06ic11na13gcacrlcs2ab6rmaii0yz0x06z5ynnljn6s";
  };

  buildInputs = [ pytest ];
  checkInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "pytest plugin allowing multiple failures per test";
    homepage = "https://github.com/okken/pytest-check";
    license = licenses.mit;
    maintainers = [ maintainers.flokli ];
  };
}

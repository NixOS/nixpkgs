{ stdenv
, buildPythonPackage
, fetchPypi
, pytest
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pytest-check";
  version = "0.3.9";

  src = fetchPypi {
    pname = "pytest_check";
    inherit version;
    sha256 = "0asrrz0fgk6wqffsz1ffd6z9xyw314fwh5bwjzcq75w8w1g4ass9";
  };

  propagatedBuildInputs = [ pytest ];
  checkInputs = [ pytestCheckHook ];

  meta = with stdenv.lib; {
    description = "pytest plugin allowing multiple failures per test";
    homepage = "https://github.com/okken/pytest-check";
    license = licenses.mit;
    maintainers = [ maintainers.flokli ];
  };
}

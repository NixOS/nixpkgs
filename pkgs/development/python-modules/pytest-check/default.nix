{ stdenv
, buildPythonPackage
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pytest-check";
  version = "0.3.9";

  src = fetchPypi {
    inherit version;
    pname = "pytest_check";
    sha256 = "0asrrz0fgk6wqffsz1ffd6z9xyw314fwh5bwjzcq75w8w1g4ass9";
  };

  checkInputs = [ pytestCheckHook ];

  meta = with stdenv.lib; {
    description = "pytest plugin allowing multiple failures per test";
    homepage = "https://github.com/okken/pytest-check";
    license = licenses.mit;
    maintainers = [ maintainers.flokli ];
  };
}

{ stdenv
, buildPythonPackage
, fetchFromGitHub
, pytest
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pytest-check";
  version = "0.3.5";

  src = fetchFromGitHub {
    owner = "okken";
    repo = "pytest-check";
    rev = version;
    sha256 = "11wb4f4sp4cr5mzqdakrbycwgfr2p1sx1l91fa6525wnfvgc0qy3";
  };

  buildInputs = [ pytest ];

  checkInputs = [ pytest pytestCheckHook ];

  meta = with stdenv.lib; {
    description = "pytest plugin allowing multiple failures per test";
    homepage = https://github.com/okken/pytest-check;
    license = licenses.mit;
    maintainers = [ maintainers.flokli ];
  };
}

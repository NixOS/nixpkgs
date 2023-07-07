{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, pytestCheckHook
, setuptools
}:

buildPythonPackage rec {
  pname = "range-typed-integers";
  version = "1.0.1";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "theCapypara";
    repo = "range-typed-integers";
    rev = version;
    sha256 = "sha256-4+XdalHq6Q2cBbuYi4x7kmCNQh1MwYf+XlLP9FzzzgE=";
  };

  format = "pyproject";

  nativeBuildInputs = [ setuptools ];

  checkInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "A package provides integer types that have a specific range of valid values";
    homepage = "https://github.com/theCapypara/range-typed-integers";
    license = [ licenses.mit ];
    maintainers = with maintainers; [ marius851000 ];
  };
}

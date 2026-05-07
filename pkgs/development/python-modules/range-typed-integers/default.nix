{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "range-typed-integers";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "theCapypara";
    repo = "range-typed-integers";
    rev = version;
    sha256 = "sha256-4+XdalHq6Q2cBbuYi4x7kmCNQh1MwYf+XlLP9FzzzgE=";
  };

  pyproject = true;

  nativeBuildInputs = [ setuptools ];

  checkInputs = [ pytestCheckHook ];

  meta = {
    description = "Package provides integer types that have a specific range of valid values";
    homepage = "https://github.com/theCapypara/range-typed-integers";
    license = [ lib.licenses.mit ];
    maintainers = with lib.maintainers; [ marius851000 ];
  };
}

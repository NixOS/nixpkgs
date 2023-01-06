{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
, hatchling
, hatch-vcs
, astor
, interface-meta
, numpy
, pandas
, pyarrow
, scipy
, sympy
, typing-extensions
, wrapt
}:

buildPythonPackage rec {
  pname = "formulaic";
  version = "0.5.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "matthewwardrop";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-sIvHTuUS/nkcDjRgZCoEOY2negIOsarzH0PeXJsavWc=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml --replace 'dynamic = ["version"]' 'version = "${version}"'
  '';

  nativeBuildInputs = [ hatchling hatch-vcs ];
  propagatedBuildInputs = [
    astor
    interface-meta
    numpy
    pandas
    scipy
    typing-extensions
    wrapt
  ];

  nativeCheckInputs = [ pytestCheckHook pyarrow sympy ];
  # AssertionError: approx() is not supported in a boolean context:
  disabledTests = [ "test_basic" "test_degree" ];

  pythonImportsCheck = [
    "formulaic"
  ];

  meta = with lib; {
    description = "High-performance implementation of Wilkinson formulas";
    homepage = "https://github.com/matthewwardrop/formulaic";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}

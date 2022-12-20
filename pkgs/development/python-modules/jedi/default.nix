{ lib
, stdenv
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, attrs
, django
, pytestCheckHook
, parso
}:

buildPythonPackage rec {
  pname = "jedi";
  version = "0.18.2";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "davidhalter";
    repo = "jedi";
    rev = "v${version}";
    hash = "sha256-hNRmUFpRzVKJQAtfsSNV4jeTR8vVj1+mGBIPO6tUGto=";
    fetchSubmodules = true;
  };

  propagatedBuildInputs = [ parso ];

  checkInputs = [
    attrs
    django
    pytestCheckHook
  ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  disabledTests = [
    # Assertions mismatches with pytest>=6.0
    "test_completion"

    # sensitive to platform, causes false negatives on darwin
    "test_import"
  ] ++ lib.optionals (stdenv.isAarch64 && pythonOlder "3.9") [
    # AssertionError: assert 'foo' in ['setup']
    "test_init_extension_module"
  ];

  meta = with lib; {
    description = "An autocompletion tool for Python that can be used for text editors";
    homepage = "https://github.com/davidhalter/jedi";
    changelog = "https://github.com/davidhalter/jedi/blob/${version}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}

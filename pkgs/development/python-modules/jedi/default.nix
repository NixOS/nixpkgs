{ lib
, stdenv
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, django
, pytestCheckHook
, parso
}:

buildPythonPackage rec {
  pname = "jedi";
  version = "0.18.1";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "davidhalter";
    repo = "jedi";
    rev = "v${version}";
    sha256 = "sha256-wWNPNi16WtefvB7GcQBnWMbHVlVzxSFs4TKRqEasuR0=";
    fetchSubmodules = true;
  };

  propagatedBuildInputs = [ parso ];

  checkInputs = [
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
    homepage = "https://github.com/davidhalter/jedi";
    description = "An autocompletion tool for Python that can be used for text editors";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}

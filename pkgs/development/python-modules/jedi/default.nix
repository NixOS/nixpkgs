{ lib
, stdenv
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, fetchPypi
, colorama
, django
, docopt
, pytestCheckHook
, parso
}:

buildPythonPackage rec {
  pname = "jedi";
  version = "0.18.0";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "davidhalter";
    repo = "jedi";
    rev = "v${version}";
    sha256 = "0d8zdj56hyxbsvvrid6r3nprm0ygxaad6zpsbhbj6k7p3dcx7acw";
    fetchSubmodules = true;
  };

  propagatedBuildInputs = [ parso ];

  checkInputs = [
    colorama
    django
    docopt
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
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ ];
  };
}

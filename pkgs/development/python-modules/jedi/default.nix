{ lib
, stdenv
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, attrs
, django_3
, pytestCheckHook
, parso
}:

buildPythonPackage rec {
  pname = "jedi";
  version = "0.19.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "davidhalter";
    repo = "jedi";
    rev = "v${version}";
    hash = "sha256-Hw0+KQkB9ICWbBJDQQmHyKngzJlJ8e3wlpe4aSrlkvo=";
    fetchSubmodules = true;
  };

  propagatedBuildInputs = [ parso ];

  nativeCheckInputs = [
    attrs
    django_3
    pytestCheckHook
  ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  disabledTests = [
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

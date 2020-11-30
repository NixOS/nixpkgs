{ lib, buildPythonPackage, fetchFromGitHub
, colorama
, hypothesis
, poetry-core
, pylama
, pytestCheckHook
}:

let
in buildPythonPackage rec {
  pname = "isort";
  version = "5.6.4";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "PyCQA";
    repo = "isort";
    rev = version;
    sha256 = "1m7jpqssnbsn1ydrw1dn7nrcrggqcvj9v6mk5ampxmvk94xd2r2q";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  checkInputs = [
    colorama
    hypothesis
    pylama
    pytestCheckHook
  ];

  postCheck = ''
    # Confirm that the produced executable script is wrapped correctly and runs
    # OK, by launching it in a subshell without PYTHONPATH
    (
      unset PYTHONPATH
      echo "Testing that `isort --version-number` returns OK..."
      $out/bin/isort --version-number
    )
  '';

  preCheck = ''
    HOME=$TMPDIR
    export PATH=$PATH:$out/bin
  '';

  pytestFlagsArray = [
    "--ignore=tests/integration/" # pulls in 10 other packages
    "--ignore=tests/unit/profiles/test_black.py" # causes infinite recursion to include black
  ];

  disabledTests = [
    "test_run" # doesn't like paths in /build
    "test_pyi_formatting_issue_942"
    "test_requirements_finder"
    "test_pipfile_finder"
    "test_main" # relies on git
    "test_command_line" # not thread safe
    "test_encoding_not_in_comment" # not python 3.9 compatible
    "test_encoding_not_in_first_two_lines" # not python 3.9 compatible
    "test_requirements_dir" # requires network
    # plugin not available
    "test_isort_literals_issue_1358"
    "test_isort_supports_formatting_plugins_issue_1353"
    "test_value_assignment_list"
    # profiles not available
    "test_isort_supports_shared_profiles_issue_970"
  ];

  meta = with lib; {
    description = "A Python utility / library to sort Python imports";
    homepage = "https://github.com/PyCQA/isort";
    license = licenses.mit;
    maintainers = with maintainers; [ couchemar nand0p ];
  };
}

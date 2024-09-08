{
  lib,
  appdirs,
  buildPythonPackage,
  cachelib,
  colorama,
  cssselect,
  fetchFromGitHub,
  fetchpatch,
  keep,
  lxml,
  pygments,
  pyquery,
  requests,
  rich,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "howdoi";
  version = "2.0.20";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "gleitz";
    repo = "howdoi";
    rev = "refs/tags/v${version}";
    hash = "sha256-u0k+h7Sp2t/JUnfPqRzDpEA+vNXB7CpyZ/SRvk+B9t0=";
  };

  patches = [
    # Bad test case fix: comparing hardcoded string to internet search result
    # PR merged: https://github.com/gleitz/howdoi/pull/497
    # Please remove on the next release
    (fetchpatch {
      url = "https://github.com/gleitz/howdoi/commit/7d24e9e1c87811a6e66d60f504381383cf1ac3fd.patch";
      hash = "sha256-AFQMnMEijaExqiimbNaVeIRmZJ4Yj0nGUOEjfsvBLh8=";
    })
  ];

  build-system = [ setuptools ];

  dependencies = [
    appdirs
    cachelib
    colorama
    cssselect
    keep
    lxml
    pygments
    pyquery
    requests
    rich
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  disabledTests = [
    "test_colorize"
    # Tests are flaky, OSError: [Errno 24] Too many open files happpens
    "test_answer_links_using_l_option"
    "test_answers_bing"
    "test_answers"
    "test_json_output"
    "test_missing_pre_or_code_query"
    "test_multiple_answers"
    "test_position"
    "test_unicode_answer"
  ];

  pythonImportsCheck = [ "howdoi" ];

  meta = with lib; {
    description = "Instant coding answers via the command line";
    homepage = "https://github.com/gleitz/howdoi";
    changelog = "https://github.com/gleitz/howdoi/blob/v${version}/CHANGES.txt";
    license = licenses.mit;
    maintainers = [ ];
  };
}

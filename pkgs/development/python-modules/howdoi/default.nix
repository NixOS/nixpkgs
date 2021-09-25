{ lib
, appdirs
, buildPythonPackage
, cachelib
, cssselect
, fetchFromGitHub
, keep
, lxml
, pygments
, pyquery
, requests
, six
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "howdoi";
  version = "2.0.17";

  src = fetchFromGitHub {
    owner = "gleitz";
    repo = pname;
    rev = "v${version}";
    sha256 = "1cc9hbnalbsd5la9wsm8s6drb79vlzin9qnv86ic81r5nq27n180";
  };

  propagatedBuildInputs = [
    appdirs
    cachelib
    cssselect
    keep
    lxml
    pygments
    pyquery
    requests
    six
  ];

  checkInputs = [
    pytestCheckHook
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  disabledTests = [
    # AssertionError: "The...
    "test_get_text_with_one_link"
    "test_get_text_without_links"
  ];

  pythonImportsCheck = [ "howdoi" ];

  meta = with lib; {
    description = "Instant coding answers via the command line";
    homepage = "https://pypi.python.org/pypi/howdoi";
    license = licenses.mit;
    maintainers = with maintainers; [ costrouc ];
  };
}

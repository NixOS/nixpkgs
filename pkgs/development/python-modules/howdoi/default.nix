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
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "howdoi";
  version = "2.0.19";

  src = fetchFromGitHub {
    owner = "gleitz";
    repo = pname;
    rev = "v${version}";
    sha256 = "0hl7cpxm4llsgw6390bpjgkzrprrpb0vxx2flgly7wiy9zl1rc5q";
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

  pythonImportsCheck = [
    "howdoi"
  ];

  meta = with lib; {
    description = "Instant coding answers via the command line";
    homepage = "https://pypi.python.org/pypi/howdoi";
    license = licenses.mit;
    maintainers = with maintainers; [ costrouc ];
  };
}

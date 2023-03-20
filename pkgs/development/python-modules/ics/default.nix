{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, tatsu
, arrow
, pytestCheckHook
, pytest-flakes
}:

buildPythonPackage rec {
  pname = "ics";
  version = "0.7.2";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "ics-py";
    repo = "ics-py";
    rev = "refs/tags/v${version}";
    hash = "sha256-hdtnET7YfSb85+TGwpwzoxOfxPT7VSj9eKSiV6AXUS8=";
  };

  propagatedBuildInputs = [
    arrow
    tatsu
  ];

  nativeCheckInputs = [
    pytest-flakes
    pytestCheckHook
  ];

  postPatch = ''
    # 0.8 will move to python-dateutil
    substituteInPlace requirements.txt \
      --replace "arrow>=0.11,<0.15" "arrow"
    substituteInPlace setup.cfg --replace "--pep8" ""
  '';

  disabledTests = [
    # Failure seems to be related to arrow > 1.0
    "test_event"
    # Broke with TatSu 5.7:
    "test_many_lines"
  ];

  pythonImportsCheck = [ "ics" ];

  meta = with lib; {
    description = "Pythonic and easy iCalendar library (RFC 5545)";
    longDescription = ''
      Ics.py is a pythonic and easy iCalendar library. Its goals are to read and
      write ics data in a developer friendly way.
    '';
    homepage = "http://icspy.readthedocs.org/en/stable/";
    changelog = "https://github.com/ics-py/ics-py/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}

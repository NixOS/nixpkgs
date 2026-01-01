{
  lib,
  buildPythonPackage,
<<<<<<< HEAD
  dnspython,
  fetchFromGitHub,
  icalendar,
  icalendar-searcher,
  lxml,
  manuel,
  pytestCheckHook,
  python,
  radicale,
=======
  fetchFromGitHub,
  icalendar,
  lxml,
  pytestCheckHook,
  python,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  recurring-ical-events,
  requests,
  hatchling,
  hatch-vcs,
  proxy-py,
  pyfakefs,
  toPythonModule,
  tzlocal,
  vobject,
  xandikos,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "caldav";
<<<<<<< HEAD
  version = "2.2.1";
=======
  version = "2.0.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "python-caldav";
    repo = "caldav";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-FsIF4BcwAUyYw8J7o4j4CnSd8eIc1Yd5WtxErC6RZ7Y=";
=======
    hash = "sha256-n7ZKTBXg66firbS34J41NrTM/PL/OrKMnS4iguRz4Ho=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [
<<<<<<< HEAD
    dnspython
    lxml
    requests
    icalendar
    icalendar-searcher
=======
    vobject
    lxml
    requests
    icalendar
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    recurring-ical-events
  ];

  nativeCheckInputs = [
<<<<<<< HEAD
    manuel
    proxy-py
    pyfakefs
    pytestCheckHook
    (toPythonModule (radicale.override { python3 = python; }))
    tzlocal
    vobject
    writableTmpDirAsHomeHook
    (toPythonModule (xandikos.override { python3Packages = python.pkgs; }))
  ];

  disabledTests = [
    # test contacts CalDAV servers on the internet
    "test_rfc8764_test_conf"
=======
    proxy-py
    pyfakefs
    pytestCheckHook
    tzlocal
    (toPythonModule (xandikos.override { python3Packages = python.pkgs; }))
    writableTmpDirAsHomeHook
  ];

  disabledTestPaths = [
    "tests/test_docs.py"
    "tests/test_examples.py"
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];

  pythonImportsCheck = [ "caldav" ];

<<<<<<< HEAD
  meta = {
    description = "CalDAV (RFC4791) client library";
    homepage = "https://github.com/python-caldav/caldav";
    changelog = "https://github.com/python-caldav/caldav/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    description = "CalDAV (RFC4791) client library";
    homepage = "https://github.com/python-caldav/caldav";
    changelog = "https://github.com/python-caldav/caldav/blob/${src.tag}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      marenz
      dotlambda
    ];
  };
}

{ lib
, anki
, beautifulsoup4
, buildPythonPackage
, callPackage
, fetchPypi
, flask
, flask-cors
, jsonschema
, pyqt5
, pyqt5_sip
, pyqt6
, pyqt6-sip
, pyqt6-webengine
, pyqtwebengine
, pytestCheckHook
, pythonOlder
, requests
, send2trash
, setuptools-scm
, waitress
}:

buildPythonPackage rec {
  pname = "aqt";
  version = "2.1.63";
  format = "wheel";

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit format pname version;
    dist = "py3";
    python = "py3";
    hash = "sha256-GxPKoRRTfNEN7Llo2qcoy9mFK23f+kDxnJmGFH0wdwU=";
  };

  propagatedBuildInputs = [
    anki
    beautifulsoup4
    flask
    flask-cors
    jsonschema
    pyqt5
    pyqt5_sip
    pyqt6
    pyqt6-sip
    pyqt6-webengine
    pyqtwebengine
    requests
    send2trash
    waitress
  ];

  pythonImportsCheck = [
    "aqt"
  ];

  passthru.tests = {
    # Check that a simple addon that uses this Python module passes a mypy check
    addon-typecheck = callPackage ./tests.nix {};
  };

  meta = with lib; {
    description = "Spaced repetition flashcard program (exported GUI functions)";
    homepage = "https://apps.ankiweb.net/";
    longDescription = ''
      Anki is a program which makes remembering things easy. Because it is a lot
      more efficient than traditional study methods, you can either greatly
      decrease your time spent studying, or greatly increase the amount you learn.

      Anyone who needs to remember things in their daily life can benefit from
      Anki. Since it is content-agnostic and supports images, audio, videos and
      scientific markup (via LaTeX), the possibilities are endless. For example:
      learning a language, studying for medical and law exams, memorizing
      people's names and faces, brushing up on geography, mastering long poems,
      or even practicing guitar chords!
    '';
    license = licenses.agpl3Plus;
    changelog = "https://changes.ankiweb.net/changes/2.1.60-69.html#changes-in-${builtins.replaceStrings ["."] [""] version}";
    maintainers = with maintainers; [ Dettorer ];
  };
}

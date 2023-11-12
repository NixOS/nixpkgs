{ lib
, beautifulsoup4
, buildPythonPackage
, callPackage
, decorator
, distro
, fetchPypi
, markdown
, orjson
, protobuf
, pytestCheckHook
, pythonOlder
, requests
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "anki";
  version = "2.1.63";
  format = "wheel";

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit format pname version;
    dist = "cp39";
    python = "cp39";
    abi = "abi3";
    # TODO: also available for windows (amd64), manylinux_2_31 (aarch64) and
    # macosx (10.13 for and x86_64 and 11.0 for arm64)
    platform = "manylinux_2_28_x86_64";
    hash = "sha256-7Hi5Os/GoOX93uKvRQfo3WP1tjZ2BnmrkB4yLWHaPYw=";
  };

  propagatedBuildInputs = [
    beautifulsoup4
    decorator
    distro
    markdown
    orjson
    protobuf
    requests
  ];

  pythonImportsCheck = [
    "anki"
  ];

  passthru.tests = {
    # Check that a simple addon that uses this Python module passes a mypy check
    addon-typecheck = callPackage ./tests.nix {};
  };

  meta = with lib; {
    description = "Spaced repetition flashcard program (exported backend functions)";
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

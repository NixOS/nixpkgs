{ lib
, stdenv
, substituteAll
, buildPythonPackage
, fetchPypi
, joblib
, segments
, attrs
, dlinfo
, typing-extensions
, espeak-ng
, pytestCheckHook
, pytest-cov
}:

buildPythonPackage rec {
  pname = "phonemizer";
  version = "3.2.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Bo+F+FqKmtxjijeHrqyvcaU+R1eLEtdzwJdDNQDNiSs=";
  };

  postPatch = ''
    sed -i '/pytest-runner/d setup.py
  '';

  patches = [
    (substituteAll {
      src = ./backend-paths.patch;
      libespeak = "${lib.getLib espeak-ng}/lib/libespeak-ng${stdenv.hostPlatform.extensions.sharedLibrary}";
      # FIXME package festival
    })
    ./remove-intertwined-festival-test.patch
  ];

  propagatedBuildInputs = [
    joblib
    segments
    attrs
    dlinfo
    typing-extensions
  ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # We tried to package festvial, but were unable to get the backend running,
  # so let's disable related tests.
  disabledTestPaths = [
    "test/test_festival.py"
  ];

  disabledTests = [
    "test_festival"
    "test_festival_path"
    "test_readme_festival_syll"
    "test_unicode"
  ];

  meta = with lib; {
    homepage = "https://github.com/bootphon/phonemizer";
    changelog = "https://github.com/bootphon/phonemizer/blob/v${version}/CHANGELOG.md";
    description = "Simple text to phones converter for multiple languages";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ];
  };
}

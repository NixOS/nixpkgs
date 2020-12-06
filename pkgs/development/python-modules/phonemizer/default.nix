{ lib
, substituteAll
, buildPythonApplication
, fetchPypi
, python3Packages
, pkgs
, joblib
, segments
, attrs
, espeak-ng
, pytestCheckHook
, pytestrunner
, pytestcov
}:

buildPythonApplication rec {
  pname = "phonemizer";
  version = "2.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "127n4f10zxq60qd8xvlc1amji4wbghqb90rfp25rzdk716kvgwab";
  };

  postPatch = ''
    sed -i -e '/\'pytest-runner\'/d setup.py
  '';

  patches = [
    (substituteAll {
      src = ./backend-paths.patch;
      espeak = "${lib.getBin espeak-ng}/bin/espeak";
      # override festival path should you try to integrate it
      festival = "";
    })
    ./remove-intertwined-festival-test.patch
  ];

  propagatedBuildInputs = [
    joblib
    segments
    attrs
  ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  checkInputs = [
    pytestCheckHook
    pytestcov
  ];

  # We tried to package festvial, but were unable to get the backend running,
  # so let's disable related tests.
  pytestFlagsArray = [
    "--ignore=test/test_festival.py"
  ];

  disabledTests = [
    "test_festival"
    "test_relative"
    "test_absolute"
    "test_readme_festival_syll"
  ];

  meta = with lib; {
    homepage = "https://github.com/bootphon/phonemizer";
    description = "Simple text to phones converter for multiple languages";
    license = licenses.gpl3;
    maintainers = with maintainers; [ hexa ];
  };
}

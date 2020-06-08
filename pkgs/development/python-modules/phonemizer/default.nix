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
, festival
, pytest
, pytestrunner
, pytestcov
}:

buildPythonApplication rec {
  pname = "phonemizer";
  version = "2.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "16hpfgzvc6r6f8khjqr62hdwsa6vhv6sxphg0879i1jfyaq5008b";
  };

  postPatch = ''
    sed -i -e '/\'pytest-runner\'/d setup.py
  '';

  patches = [
    (substituteAll {
      src = ./espeak-path.patch;
      espeak = "${lib.getBin espeak-ng}/bin/espeak";
    })
    (substituteAll {
      src = ./festival-path.patch;
      festival = "${lib.getBin festival}/bin/festival";
    })
  ];

  propagatedBuildInputs = [
    joblib
    segments
    attrs
  ];

  # tests fail in test_festival.py
  #doCheck = false;

  checkInputs = [
    pytest
    pytestrunner
    pytestcov
  ];

  meta = with lib; {
    homepage = "https://github.com/bootphon/phonemizer";
    description = "Simple text to phones converter for multiple languages";
    license = licenses.gpl3;
    maintainers = with maintainers; [ hexa ];
  };
}

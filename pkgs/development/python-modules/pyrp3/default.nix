{ lib
, fetchFromGitHub
, fetchpatch
, buildPythonPackage
, myhdl
, rpyc
, cached-property
, numpy
}:

buildPythonPackage {
  pname = "pyrp3";
  version = "unstable-2022-05-09";
  # There's no pypi source
  src = fetchFromGitHub {
    owner = "linien-org";
    repo = "pyrp3";
    rev = "f13da68d825ede3091a082edf99339c5ed736bd2";
    hash = "sha256-hmPG7jBPUSVnsLZOS0pf2c5gibWx0al0rAso1OTAZ1E=";
  };

  patches = [
    # https://github.com/linien-org/pyrp3/pull/2
    (fetchpatch {
      name = "fix-libmonitor.so-lookup.patch";
      url = "https://github.com/doronbehar/pyrp3/commit/87e8df4be676ee52661757e11c0d2bdc3fefa82c.patch";
      hash = "sha256-1lgfQvKa/5wakjDgfp/CY2Kne36vqK6wnFXGCDKFxzc=";
    })
  ];
  # Install libmonitor.so
  preInstall = ''
    python setup.py lib_install --prefix=$out
  '';
  # No tests and these try to load libmonitor.so from /
  doCheck = false;
  pythonImportsCheck = [
    "PyRedPitaya"
    # Imported in ../linien-server/
    "PyRedPitaya.board"
  ];

  propagatedBuildInputs = [
    myhdl
    rpyc
    cached-property
    numpy
  ];

  meta = with lib; {
    description = "Python 3 port of PyRedPitaya library providing access to Red Pitaya registers";
    homepage = "https://github.com/linien-org/pyrp3";
    license = licenses.bsd3;
    maintainers = with maintainers; [ doronbehar ];
  };
}

{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "python-crfsuite";
  version = "0.9.7";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ryfcdfpqbrf8rcd2rlay2gfiba3px3q508543jf81shrv93hi9v";
  };

  preCheck = ''
    # make sure import the built version, not the source one
    rm -r pycrfsuite
  '';

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pycrfsuite"
  ];

  meta = with lib; {
    description = "Python binding for CRFsuite";
    homepage = "https://github.com/scrapinghub/python-crfsuite";
    license = licenses.mit;
    maintainers = teams.tts.members;
  };
}

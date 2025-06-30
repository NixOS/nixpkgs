{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  cython,
}:

buildPythonPackage rec {
  pname = "python-crfsuite";
  version = "0.9.11";
  format = "setuptools";

  src = fetchPypi {
    inherit version;
    pname = "python_crfsuite";
    hash = "sha256-bv+WXKcFZzltgiyaNep0sPftsn2UcVJJl72r56baX1o=";
  };

  preCheck = ''
    # make sure import the built version, not the source one
    rm -r pycrfsuite
  '';

  build-system = [
    cython
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pycrfsuite" ];

  meta = with lib; {
    description = "Python binding for CRFsuite";
    homepage = "https://github.com/scrapinghub/python-crfsuite";
    license = licenses.mit;
    teams = [ teams.tts ];
  };
}

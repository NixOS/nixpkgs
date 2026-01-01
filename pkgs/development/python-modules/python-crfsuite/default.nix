{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  cython,
}:

buildPythonPackage rec {
  pname = "python-crfsuite";
<<<<<<< HEAD
  version = "0.9.12";
=======
  version = "0.9.11";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  format = "setuptools";

  src = fetchPypi {
    inherit version;
    pname = "python_crfsuite";
<<<<<<< HEAD
    hash = "sha256-2zf8zDvY8MScKKdpfKecidZ7P9W/EZEihmFpJArExIA=";
=======
    hash = "sha256-bv+WXKcFZzltgiyaNep0sPftsn2UcVJJl72r56baX1o=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    description = "Python binding for CRFsuite";
    homepage = "https://github.com/scrapinghub/python-crfsuite";
    changelog = "https://github.com/scrapinghub/python-crfsuite/blob/${version}/CHANGES.rst";
    license = lib.licenses.mit;
    teams = [ lib.teams.tts ];
=======
  meta = with lib; {
    description = "Python binding for CRFsuite";
    homepage = "https://github.com/scrapinghub/python-crfsuite";
    license = licenses.mit;
    teams = [ teams.tts ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}

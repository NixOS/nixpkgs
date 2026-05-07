{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  cython,
}:

buildPythonPackage rec {
  pname = "python-crfsuite";
  version = "0.9.12";
  format = "setuptools";

  src = fetchPypi {
    inherit version;
    pname = "python_crfsuite";
    hash = "sha256-2zf8zDvY8MScKKdpfKecidZ7P9W/EZEihmFpJArExIA=";
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

  meta = {
    description = "Python binding for CRFsuite";
    homepage = "https://github.com/scrapinghub/python-crfsuite";
    changelog = "https://github.com/scrapinghub/python-crfsuite/blob/${version}/CHANGES.rst";
    license = lib.licenses.mit;
    teams = [ lib.teams.tts ];
  };
}

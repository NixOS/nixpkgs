{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "python-crfsuite";
  version = "0.9.10";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-84UkYx4rUzNB8Q8sd2iScNxuzVmFSV3M96o3sQRbwuU=";
  };

  preCheck = ''
    # make sure import the built version, not the source one
    rm -r pycrfsuite
  '';

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pycrfsuite" ];

  meta = with lib; {
    description = "Python binding for CRFsuite";
    homepage = "https://github.com/scrapinghub/python-crfsuite";
    license = licenses.mit;
    maintainers = teams.tts.members;
  };
}

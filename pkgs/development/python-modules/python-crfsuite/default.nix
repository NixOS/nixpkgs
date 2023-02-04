{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonAtLeast
}:

buildPythonPackage rec {
  pname = "python-crfsuite";
  version = "0.9.8";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-DgPPbro2KHF8zwbfoPSiuoYohgrbF0y/0lCnpGkoZaE=";
  };

  preCheck = ''
    # make sure import the built version, not the source one
    rm -r pycrfsuite
  '';

  nativeCheckInputs = [
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

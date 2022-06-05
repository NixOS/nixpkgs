{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, setuptools-scm
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "inflect";
  version = "5.4.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-tY1YxOc//KmyXgdcHE/Jyt7LtcmdfNnzze3ac+zoPBw=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "inflect" ];

  meta = with lib; {
    description = "Correctly generate plurals, singular nouns, ordinals, indefinite articles";
    homepage = "https://github.com/jaraco/inflect";
    changelog = "https://github.com/jaraco/inflect/blob/v${version}/CHANGES.rst";
    license = licenses.mit;
    maintainers = teams.tts.members;
  };
}

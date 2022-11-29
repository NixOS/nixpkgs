{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, setuptools-scm
, pydantic
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "inflect";
  version = "6.0.0";
  disabled = isPy27;
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-C8FRbsJyXi2CIXB6YSJFCTy28c6iCc/Yy9T8Xpb6Y2U=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [ pydantic ];

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

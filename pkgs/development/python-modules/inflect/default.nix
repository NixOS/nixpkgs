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
  version = "6.0.4";
  disabled = isPy27;
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-GEJkmhe2ytZoEqXJvfrLYxDh57bdijHwJnZt8bYmEus=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [ pydantic ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "inflect" ];

  meta = with lib; {
    description = "Correctly generate plurals, singular nouns, ordinals, indefinite articles";
    homepage = "https://github.com/jaraco/inflect";
    changelog = "https://github.com/jaraco/inflect/blob/v${version}/CHANGES.rst";
    license = licenses.mit;
    maintainers = teams.tts.members;
  };
}

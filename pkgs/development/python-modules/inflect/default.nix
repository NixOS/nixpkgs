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
  version = "7.0.0";
  disabled = isPy27;
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Y9qTJa0p2oHsI+BVtBIleVq3k7TstIO+XcH6Nj/UcX4=";
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

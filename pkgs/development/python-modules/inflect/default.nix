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
  version = "6.0.2";
  disabled = isPy27;
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-8aa8sBBQRviWGf3hp9BExhLGFMLYXvGCWC2dybhtMJo=";
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

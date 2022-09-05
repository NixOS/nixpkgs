{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, setuptools-scm
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "inflect";
  version = "5.6.2";
  disabled = isPy27;
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-qtx+1zko9eAUEpeUu6wDBYzKNdCpc6X8TrRcf6JgBfk=";
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

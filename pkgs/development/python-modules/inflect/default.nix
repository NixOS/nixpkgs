{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, setuptools_scm
, toml
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "inflect";
  version = "5.2.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "30e9d9d372e693739beaae1345dc53c48871ca70c5c7060edd3e7e77802bf945";
  };

  nativeBuildInputs = [ setuptools_scm toml ];

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "inflect" ];

  meta = with lib; {
    description = "Correctly generate plurals, singular nouns, ordinals, indefinite articles";
    homepage = "https://github.com/jaraco/inflect";
    changelog = "https://github.com/jaraco/inflect/blob/v${version}/CHANGES.rst";
    license = licenses.mit;
  };
}

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
  version = "5.3.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "41a23f6788962e9775e40e2ecfb1d6455d02de315022afeedd3c5dc070019d73";
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

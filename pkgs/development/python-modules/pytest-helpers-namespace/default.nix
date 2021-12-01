{ buildPythonPackage
, fetchPypi
, pytestCheckHook
, isPy27
, lib
, setuptools
, setuptools-declarative-requirements
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "pytest-helpers-namespace";
  version = "2021.4.29";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "183524e3db4e2a1fea92e0ca3662a624ba44c9f3568da15679d7535ba6838a6a";
  };

  nativeBuildInputs = [ setuptools setuptools-declarative-requirements setuptools-scm ];

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pytest_helpers_namespace" ];

  meta = with lib; {
    homepage = "https://github.com/saltstack/pytest-helpers-namespace";
    description = "PyTest Helpers Namespace";
    license = licenses.asl20;
    maintainers = [ maintainers.kiwi ];
  };
}

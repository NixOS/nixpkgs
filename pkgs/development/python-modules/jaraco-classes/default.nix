{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  isPy27,
  setuptools-scm,
  more-itertools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "jaraco-classes";
  version = "3.4.0";
  format = "pyproject";

  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "jaraco";
    repo = "jaraco.classes";
    tag = "v${version}";
    sha256 = "sha256-pXDsLKiEru+UXcEBT4/cP1u8s9vSn1Zhf7Qnwy9Zr0I=";
  };

  pythonNamespaces = [ "jaraco" ];

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [ more-itertools ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Utility functions for Python class constructs";
    homepage = "https://github.com/jaraco/jaraco.classes";
    license = licenses.mit;
  };
}

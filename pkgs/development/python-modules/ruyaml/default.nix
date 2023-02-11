{ lib
, buildPythonPackage
, distro
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, setuptools-scm
, setuptools-scm-git-archive
}:

buildPythonPackage rec {
  pname = "ruyaml";
  version = "0.91.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "pycontribs";
    repo = pname;
    rev = "v${version}";
    sha256 = "0gxvwry7n1gczxkjzyfrr3fammllkvnnamja4yln8xrg3n1h89al";
  };

  nativeBuildInputs = [
    setuptools-scm
    setuptools-scm-git-archive
  ];

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  propagatedBuildInputs = [
    distro
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "ruyaml"
  ];

  meta = with lib; {
    description = "YAML 1.2 loader/dumper package for Python";
    homepage = "https://ruyaml.readthedocs.io/";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}

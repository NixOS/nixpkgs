{ lib, buildPythonPackage, fetchFromGitHub, isPy27
, setuptools_scm, toml
, more-itertools
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "jaraco.classes";
  version = "3.1.1";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "jaraco";
    repo = "jaraco.classes";
    rev = "v${version}";
    sha256 = "0wzrcsxi9gb65inayg0drm08iaw37jm1lqxhz3860i6pwjh503pr";
  };

  pythonNamespaces = [ "jaraco" ];

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [ setuptools_scm toml ];

  propagatedBuildInputs = [ more-itertools ];

  checkInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Utility functions for Python class constructs";
    homepage = "https://github.com/jaraco/jaraco.classes";
    license = licenses.mit;
  };
}

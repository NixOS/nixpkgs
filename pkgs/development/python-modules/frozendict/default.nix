{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "frozendict";
  version = "2.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Marco-Sulla";
    repo = "python-frozendict";
    tag = "v${version}";
    hash = "sha256-oYrIhRh1E9EHzY2lyT1aIxO6JrAqtuZJt0GmqMolOH0=";
  };

  # build C version if it exists
  preBuild = ''
    version_str=$(python -c 'import sys; print("_".join(map(str, sys.version_info[:2])))')
    if test -f src/frozendict/c_src/$version_str/frozendictobject.c; then
      export CIBUILDWHEEL=1
      export FROZENDICT_PURE_PY=0
    else
      export CIBUILDWHEEL=0
      export FROZENDICT_PURE_PY=1
    fi
  '';

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "frozendict" ];

  meta = {
    description = "Module for immutable dictionary";
    homepage = "https://github.com/Marco-Sulla/python-frozendict";
    changelog = "https://github.com/Marco-Sulla/python-frozendict/releases/tag/v${version}";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ pbsds ];
  };
}

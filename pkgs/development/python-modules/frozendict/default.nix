{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "frozendict";
  version = "2.4.7";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "Marco-Sulla";
    repo = "python-frozendict";
    tag = "v${version}";
    hash = "sha256-ehx8X3jbKls/DVgCzWJ+nTX+m/Cdknnu/sjrAMxnJFo=";
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

  meta = with lib; {
    description = "Module for immutable dictionary";
    homepage = "https://github.com/Marco-Sulla/python-frozendict";
    changelog = "https://github.com/Marco-Sulla/python-frozendict/releases/tag/v${version}";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ pbsds ];
  };
}

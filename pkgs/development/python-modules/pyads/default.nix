{
  lib,
  adslib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyads";
  version = "3.4.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "stlehmann";
    repo = "pyads";
    rev = "refs/tags/${version}";
    hash = "sha256-OvDh92fwHW+UzEO5iqVOY7d5H0Es6CJK/f/HCyLO9J4=";
  };

  build-system = [ setuptools ];

  buildInputs = [ adslib ];

  patchPhase = ''
    substituteInPlace pyads/pyads_ex.py \
      --replace-fail "ctypes.CDLL(adslib)" "ctypes.CDLL(\"${adslib}/lib/adslib.so\")"
  '';

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pyads" ];

  meta = with lib; {
    description = "Python wrapper for TwinCAT ADS library";
    homepage = "https://github.com/MrLeeh/pyads";
    changelog = "https://github.com/stlehmann/pyads/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ jamiemagee ];
  };
}

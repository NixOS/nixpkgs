{
  lib,
  adslib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyads";
  version = "3.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "stlehmann";
    repo = "pyads";
    tag = version;
    hash = "sha256-Uh8QS9l0O1UCOM03eZ3Wo8aohgUxSbErRX2/zEUP10k=";
  };

  build-system = [ setuptools ];

  buildInputs = [ adslib ];

  patchPhase = ''
    substituteInPlace pyads/pyads_ex.py \
      --replace-fail "ctypes.CDLL(adslib)" "ctypes.CDLL(\"${adslib}/lib/adslib.so\")"
  '';

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pyads" ];

  meta = {
    description = "Python wrapper for TwinCAT ADS library";
    homepage = "https://github.com/MrLeeh/pyads";
    changelog = "https://github.com/stlehmann/pyads/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jamiemagee ];
  };
}

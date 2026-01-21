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
  version = "3.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "stlehmann";
    repo = "pyads";
    tag = version;
    hash = "sha256-eQC2ozJ5bKuhyInZDq8ZZNa9OGIN3tRjSHEPoqIU/jc=";
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

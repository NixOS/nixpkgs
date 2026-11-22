{
  lib,
  buildPythonPackage,
  docopt,
  fetchFromGitHub,
  setuptools,
  jdk11,
  psutil,
}:

buildPythonPackage (finalAttrs: {
  pname = "adb-enhanced";
  version = "2.11.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ashishb";
    repo = "adb-enhanced";
    tag = finalAttrs.version;
    hash = "sha256-RKMF2Cn3wd5p3SdC22BO5AeINaq8u3+1t+3QkXYjbpE=";
  };

  build-system = [ setuptools ];

  dependencies = [
    psutil
    docopt
  ];

  postPatch = ''
    substituteInPlace adbe/adb_enhanced.py \
      --replace-fail "f\"java" "f\"${lib.getExe jdk11}"
  '';

  # Disable tests because they require a dedicated Android emulator
  doCheck = false;

  pythonImportsCheck = [ "adbe" ];

  meta = {
    description = "Tool for Android testing and development";
    homepage = "https://github.com/ashishb/adb-enhanced";
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode
    ];
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ vtuan10 ];
    mainProgram = "adbe";
  };
})

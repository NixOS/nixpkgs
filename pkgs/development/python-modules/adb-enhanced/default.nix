{
  lib,
  buildPythonPackage,
  docopt,
  fetchFromGitHub,
  fetchpatch,
  setuptools,
  jdk11,
  psutil,
}:

buildPythonPackage (finalAttrs: {
  pname = "adb-enhanced";
  version = "2.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ashishb";
    repo = "adb-enhanced";
    tag = finalAttrs.version;
    hash = "sha256-YuQgz3WeN50hg/IgdoNV61St9gpu6lcgFfKCfI/ENl0=";
  };
  patches = [
    # psutil==7.2.1 -> psutil==7.2.2
    (fetchpatch {
      url = "https://github.com/ashishb/adb-enhanced/pull/337.patch";
      hash = "sha256-BRpdgLS6CNkmyj+OwnIaqfkmz1jzZg/qtoiN32jUIog=";
    })
  ];

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

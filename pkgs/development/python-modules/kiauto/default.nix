{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  setuptools,

  xvfbwrapper,
  psutil,

  kicadFull,
  kicad,
}:
buildPythonPackage (finalAttrs: {
  pname = "kiauto";
  version = "2.3.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "INTI-CMNB";
    repo = "KiAuto";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6USOb5iKjVKF6SOMVe5/TJoZHAUylCG0i5OjX88vZyU=";
  };

  postPatch = ''
    substituteInPlace kiauto/misc.py \
      --replace-fail "KICAD_SHARE = '/usr/share/kicad/'" "KICAD_SHARE = '${kicadFull}'"
  '';

  build-system = [ setuptools ];

  dependencies = [
    xvfbwrapper
    psutil
    kicad
  ];

  pythonImportsCheck = [ "kiauto" ];

  meta = {
    description = "KiCad automation scripts library";
    homepage = "https://github.com/INTI-CMNB/KiAuto";
    changelog = "https://github.com/INTI-CMNB/KiAuto/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.ryand56 ];
  };
})

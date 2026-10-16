{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  xvfbwrapper,
  psutil,
  kicadPkg,
  kicad,
}:

buildPythonPackage (finalAttrs: {
  pname = "kiauto";
  version = "2.3.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "INTI-CMNB";
    repo = "KiAuto";
    rev = "v${finalAttrs.version}";
    hash = "sha256-neiGVOF6KWjRu15dpKk7SILuVzYsG2n+o/xFaLAXKyY=";
  };

  build-system = [ setuptools ];

  dependencies = [
    xvfbwrapper
    psutil
    kicadPkg
    kicad
  ];

  postPatch = ''
    substituteInPlace kiauto/misc.py \
      --replace "KICAD_SHARE = '/usr/share/kicad/'" "KICAD_SHARE = '${kicadPkg}'"
  '';

  pythonImportsCheck = [ "kiauto" ];

  __structuredAttrs = true;

  meta = {
    description = "Automation scripts for KiCad";
    homepage = "https://github.com/INTI-CMNB/KiAuto";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ n3tcat ];
  };
})

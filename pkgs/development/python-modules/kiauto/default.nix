{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  xvfbwrapper,
  psutil,
  kicad9Pkg,
  kicad9,
}:

buildPythonPackage (finalAttrs: {
  pname = "kiauto";
  version = "2.3.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "INTI-CMNB";
    repo = "KiAuto";
    rev = "v${finalAttrs.version}";
    hash = "sha256-iK1IlzZ29sDnxHY0gHbTr/HdADXYJWzGx33GsjUa0tE=";
  };

  build-system = [ setuptools ];

  dependencies = [
    xvfbwrapper
    psutil
    kicad9Pkg
    kicad9
  ];

  postPatch = ''
    substituteInPlace kiauto/misc.py \
      --replace-fail "KICAD_SHARE = '/usr/share/kicad/'" "KICAD_SHARE = '${kicad9Pkg}'"
  '';

  pythonImportsCheck = [ "kiauto" ];

  meta = {
    description = "Automation scripts for KiCad";
    homepage = "https://github.com/INTI-CMNB/KiAuto";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ scd31 ];
  };
})

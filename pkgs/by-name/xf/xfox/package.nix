{
  python3Packages,
  fetchFromGitHub,
  lib,
}:
python3Packages.buildPythonApplication rec {
  pname = "xfox";
  version = "1.0.0";
  pyproject = true;
  src = fetchFromGitHub {
    owner = "pxlman";
    repo = "xfox";
    tag = "v${version}";
    hash = "sha256-gbcJ02ZaPqiCo0VHnVOYzrWR00dQXgKavFTgP+6rS34=";
  };
  build-system = [ python3Packages.setuptools ];
  dependencies = [
    python3Packages.evdev
    python3Packages.libevdev
  ];
  postPatch = ''
    substituteInPlace setup.py --replace-fail "evdev-binary" "evdev"
  '';
  meta = {
    description = "Tool to remap gamepads to act as a virtual xbox gamepad.";
    homepage = "https://github.com/pxlman/xfox";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      pxlman
    ];
    mainProgram = "xfox";
  };
}

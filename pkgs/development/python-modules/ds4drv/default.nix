{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  evdev,
  pyudev,
  bluez,
  setuptools,
}:

buildPythonPackage rec {
  pname = "ds4drv";
  version = "0.5.1";

  pyproject = true;
  build-system = [ setuptools ];

  # PyPi only carries py3 wheel
  src = fetchFromGitHub {
    owner = "chrippa";
    repo = "ds4drv";
    rev = "v${version}";
    sha256 = "0vinpla0apizzykcyfis79mrm1i6fhns83nkzw85svypdhkx2g8v";
  };

  postPatch = ''
    substituteInPlace ds4drv/config.py \
      --replace-fail SafeConfigParser ConfigParser
  '';

  dependencies = [
    evdev
    pyudev
  ];

  buildInputs = [ bluez ];

  meta = {
    description = "Userspace driver for the DualShock 4 controller";
    mainProgram = "ds4drv";
    homepage = "https://github.com/chrippa/ds4drv";
    license = lib.licenses.mit;
  };
}

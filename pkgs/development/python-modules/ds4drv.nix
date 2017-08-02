{ lib, fetchFromGitHub, buildPythonPackage
, evdev, pyudev
, bluez
}:

buildPythonPackage rec {
  pname = "ds4drv";
  name = "${pname}-${version}";
  version = "0.5.1";

  # PyPi only carries py3 wheel
  src = fetchFromGitHub {
    owner = "chrippa";
    repo = "ds4drv";
    rev = "v${version}";
    sha256 = "0vinpla0apizzykcyfis79mrm1i6fhns83nkzw85svypdhkx2g8v";
  };

  propagatedBuildInputs = [ evdev pyudev ];

  buildInputs = [ bluez ];

  meta = {
    description = "Userspace driver for the DualShock 4 controller";
    homepage = https://github.com/chrippa/ds4drv;
    license = lib.licenses.mit;
  };
}

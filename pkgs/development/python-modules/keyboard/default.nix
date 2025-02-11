{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
}:

buildPythonPackage rec {
  pname = "keyboard";
  version = "0.13.5";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "boppreh";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-U4GWhPp28azBE3Jn9xpLxudOKx0PjnYO77EM2HsJ9lM=";
  };

  pythonImportsCheck = [ "keyboard" ];

  # Specific OS tests are being run for other OS, like
  # winmouse on Linux, which provides the following error:
  # AttributeError: module 'ctypes' has no attribute 'WinDLL'
  doCheck = false;

  meta = with lib; {
    description = "Hook and simulate keyboard events on Windows and Linux";
    homepage = "https://github.com/boppreh/keyboard";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}

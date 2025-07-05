{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  version = "0.4.0";
  format = "setuptools";
  pname = "undervolt";

  src = fetchFromGitHub {
    owner = "georgewhewell";
    repo = "undervolt";
    rev = version;
    hash = "sha256-G+CK/lnZXkQdyNZPqY9P3owVJsd22H3K8wSpjHFG0ow=";
  };

  meta = with lib; {
    homepage = "https://github.com/georgewhewell/undervolt/";
    description = "Program for undervolting Intel CPUs on Linux";
    mainProgram = "undervolt";

    longDescription = ''
      Undervolt is a program for undervolting Intel CPUs under Linux. It works in a similar
      manner to the Windows program ThrottleStop (i.e, MSR 0x150). You can apply a fixed
      voltage offset to one of 5 voltage planes, and override your systems temperature
      target (CPU will throttle when this temperature is reached).
    '';
    license = licenses.gpl2Only;
    platforms = [ "x86_64-linux" ];
  };
}

{ stdenv, lib, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "pyserial";
  version="3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1nyd4m4mnrz8scbfqn4zpq8gnbl4x42w5zz62vcgpzqd2waf0xrw";
  };

  checkPhase = "python -m unittest discover -s test";
  doCheck = !stdenv.hostPlatform.isDarwin; # broken on darwin

  meta = with lib; {
    homepage = "https://github.com/pyserial/pyserial";
    license = licenses.psfl;
    description = "Python serial port extension";
    maintainers = with maintainers; [ makefu ];
  };
}

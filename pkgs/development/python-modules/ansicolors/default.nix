{ stdenv, buildPythonPackage, fetchPypi, pytest }:

buildPythonPackage rec {
  pname = "ansicolors";
  version = "1.1.8";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "99f94f5e3348a0bcd43c82e5fc4414013ccc19d70bd939ad71e0133ce9c372e0";
  };

  checkInputs = [ pytest ];

  checkPhase = ''
    py.test
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/verigak/colors/;
    description = "ANSI colors for Python";
    license = licenses.isc;
    maintainers = with maintainers; [ copumpkin ];
  };
}

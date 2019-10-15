{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "EasyProcess";
  version = "0.2.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f757cd16cdab5b87117b4ee6cf197f99bfa109253364c7bd717ad0bcd39218a0";
  };

  # No tests
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Easy to use python subprocess interface";
    homepage = https://github.com/ponty/EasyProcess;
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ layus ];
  };
}

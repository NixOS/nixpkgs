{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "EasyProcess";
  version = "0.2.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0gdl6y37g8rns2i26d2zlx7x4kbpql9h5qd8k23ka69q6frcpb8k";
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

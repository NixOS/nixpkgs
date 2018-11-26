{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "pysocks";
  version = "1.6.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0h9zwr8z9j6l313ns335irjrkk6qnk4qzvwmjqygrp7mbwi9lh82";
  };

  doCheck = false;

  meta = with stdenv.lib; {
    description = "SOCKS module for Python";
    license     = licenses.bsd3;
    maintainers = with maintainers; [ thoughtpolice ];
  };

}

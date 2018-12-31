{ stdenv, buildPythonPackage, fetchPypi, isPy3k
}:

buildPythonPackage rec {
  pname   = "httptools";
  version = "0.0.11";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1idps97v4ssk9v10vdza942w5ixqa9rm84cqn0lcms7hpqxp1iq4";
  };

  meta = with stdenv.lib; {
    description = "Fast HTTP Parser";
    homepage    = https://github.com/MagicStack/httptools;
    license     = licenses.mit;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}

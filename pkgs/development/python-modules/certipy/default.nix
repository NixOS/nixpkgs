{ lib
, buildPythonPackage
, fetchPypi
, pyopenssl
}:

buildPythonPackage rec {
  pname = "certipy";
  version = "0.1.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0n980gqpzh0fm58h3i4mi2i10wgj606lscm1r5sk60vbf6vh8mv9";
  };

  propagatedBuildInputs = [ pyopenssl ];

  doCheck = false; #no tests were included

  meta = with lib; {
    homepage = "https://github.com/LLNL/certipy";
    description = "wrapper for pyOpenSSL";
    license = licenses.bsd3;
    maintainers = with maintainers; [ isgy ];
  };

}

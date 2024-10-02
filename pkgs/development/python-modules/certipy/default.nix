{
  lib,
  buildPythonPackage,
  fetchPypi,
  pyopenssl,
}:

buildPythonPackage rec {
  pname = "certipy";
  version = "0.2.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-DA6nslJItC+5MPMBc6eMAp5rpn4u+VmMpEcNiXXJy7Y=";
  };

  propagatedBuildInputs = [ pyopenssl ];

  doCheck = false; # no tests were included

  meta = with lib; {
    homepage = "https://github.com/LLNL/certipy";
    description = "wrapper for pyOpenSSL";
    mainProgram = "certipy";
    license = licenses.bsd3;
    maintainers = with maintainers; [ isgy ];
  };
}

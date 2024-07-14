{
  lib,
  buildPythonPackage,
  fetchPypi,
  isPyPy,
  paramiko,
}:

buildPythonPackage rec {
  pname = "pysftp";
  version = "0.2.9";
  format = "setuptools";
  disabled = isPyPy;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-+/VagC501mNnNACs2S1Tc8HH7pTXZbQo2fl3VnrEhUo=";
  };

  propagatedBuildInputs = [ paramiko ];

  meta = with lib; {
    homepage = "https://bitbucket.org/dundeemt/pysftp";
    description = "Friendly face on SFTP";
    license = licenses.mit;
    longDescription = ''
      A simple interface to SFTP. The module offers high level abstractions
      and task based routines to handle your SFTP needs. Checkout the Cook
      Book, in the docs, to see what pysftp can do for you.
    '';
  };
}

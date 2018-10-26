{ stdenv
, buildPythonPackage
, fetchPypi
, isPyPy
, paramiko
}:

buildPythonPackage rec {
  pname = "pysftp";
  version = "0.2.9";
  disabled = isPyPy;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0jl5qix5cxzrv4lb8rfpjkpcghbkacnxkb006ikn7mkl5s05mxgv";
  };

  propagatedBuildInputs = [ paramiko ];

  meta = with stdenv.lib; {
    homepage = https://bitbucket.org/dundeemt/pysftp;
    description = "A friendly face on SFTP";
    license = licenses.mit;
    longDescription = ''
      A simple interface to SFTP. The module offers high level abstractions
      and task based routines to handle your SFTP needs. Checkout the Cook
      Book, in the docs, to see what pysftp can do for you.
    '';
  };

}

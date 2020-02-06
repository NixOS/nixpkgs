{ stdenv, fetchurl, python2Packages }:

python2Packages.buildPythonApplication rec {
  pname = "hy";
  version = "0.17.0";

  src = python2Packages.fetchPypi {
    inherit pname version;
    sha256 = "1gdbqsirsdxj320wnp7my5awzs1kfs6m4fqmkzbd1zd47qzj0zfi";
  };

  propagatedBuildInputs = with python2Packages; [
    appdirs
    astor
    clint
    fastentrypoints
    funcparserlib
    rply
  ];

  meta = with stdenv.lib; {
    description = "A LISP dialect embedded in Python";
    homepage = "http://hylang.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ nixy ];
    platforms = platforms.all;
  };
}

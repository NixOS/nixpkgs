{ stdenv, fetchurl, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  name = "hy-${version}";
  version = "0.15.0";

  src = fetchurl {
    url = "mirror://pypi/h/hy/${name}.tar.gz";
    sha256 = "01vzaib1imr00j5d7f7xk44v800h06s3yv9inhlqm6f3b25ywpl1";
  };

  propagatedBuildInputs = with pythonPackages; [
    appdirs
    astor
    clint
    funcparserlib
    rply
  ];

  meta = {
    description = "A LISP dialect embedded in Python";
    homepage = http://hylang.org/;
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.nixy ];
    platforms = stdenv.lib.platforms.all;
  };
}

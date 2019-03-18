{ stdenv, fetchurl, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  name = "hy-${version}";
  version = "0.16.0";

  src = fetchurl {
    url = "mirror://pypi/h/hy/${name}.tar.gz";
    sha256 = "00lq38ppikrpyw38fn5iy9iwrsamsv22507cp146dsjbzkwjpzrd";
  };

  patches = [ ./bytecode-error-handling.patch ];

  propagatedBuildInputs = with pythonPackages; [
    appdirs
    astor
    clint
    fastentrypoints
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

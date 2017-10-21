{ stdenv, fetchurl, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  name = "hy-${version}";
  version = "0.12.1";

  src = fetchurl {
    url = "mirror://pypi/h/hy/${name}.tar.gz";
    sha256 = "1fjip998k336r26i1gpri18syvfjg7z46wng1n58dmc238wm53sx";
  };

  propagatedBuildInputs = with pythonPackages; [ appdirs clint astor rply ];

  meta = {
    description = "A LISP dialect embedded in Python";
    homepage = http://hylang.org/;
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.nixy ];
    platforms = stdenv.lib.platforms.all;
  };
}

{ stdenv, fetchurl, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  name = "hy-${version}";
  version = "0.11.1";

  src = fetchurl {
    url = "mirror://pypi/h/hy/${name}.tar.gz";
    sha256 = "1msqv747iz12r73mz4qvsmlwkddwjvrahlrk7ysrcz07h7dsscxs";
  };

  buildInputs = [ pythonPackages.appdirs ];
  propagatedBuildInputs = [ pythonPackages.clint pythonPackages.astor pythonPackages.rply ];

  meta = {
    description = "A LISP dialect embedded in Python";
    homepage = http://hylang.org/;
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.nixy ];
    platforms = stdenv.lib.platforms.all;
  };
}

{ stdenv, fetchurl, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  name = "hy-${version}";
  version = "0.14.0";

  src = fetchurl {
    url = "mirror://pypi/h/hy/${name}.tar.gz";
    sha256 = "0cbdh1q0zm00p4h7i44kir4qhw0p6sid78xf6llrx2p21llsnv98";
  };

  propagatedBuildInputs = with pythonPackages; [ appdirs clint astor rply ];

  # The build generates a .json parser file in the home directory under .cache.
  # This is needed to get it to not try and open files in /homeless-shelter
  preConfigure = ''
    export HOME=$TMP
  '';

  meta = {
    description = "A LISP dialect embedded in Python";
    homepage = http://hylang.org/;
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.nixy ];
    platforms = stdenv.lib.platforms.all;
  };
}

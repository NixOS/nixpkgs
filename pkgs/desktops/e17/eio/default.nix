{ stdenv, fetchurl, pkgconfig, eet, eina, ecore }:
stdenv.mkDerivation rec {
  name = "eio-${version}";
  version = "1.7.5";
  src = fetchurl {
    url = "http://download.enlightenment.org/releases/${name}.tar.bz2";
    sha256 = "1bsam5q364kc4xwfv7pql6686gj0byhk42zwjqx9ajf70l23kss6";
  };
  buildInputs = [ pkgconfig eet eina ecore ];
  meta = {
    description = "A library that integrates with EFL to provide efficient filesystem IO";
    longDescription = ''
      Eio integrates with EFL (Ecore, Eina) to provide efficient filesystem Input/Output.
      It use the best techniques to achieve such purpose, like using at-variants, splice,
      properly handling errors and doing it in an asynchronous fashion by means of worker
      threads. It is also ported to Windows, so multi-platform.

      Whenever you need to list a directory, copy, move or delete files, Eio will do that
      task better than you'd achieve with naive implementations, and it is easy to use. 
    '';
    homepage = http://enlightenment.org/;
    license = stdenv.lib.licenses.lgpl21;
  };
}

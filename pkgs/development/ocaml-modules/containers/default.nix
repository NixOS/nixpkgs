{ lib, fetchFromGitHub, buildDunePackage, ocaml
, iter, result, uchar
, gen, mdx, ounit, qcheck, uutf
}:

buildDunePackage rec {
  version = "2.7";
  pname = "containers";

  src = fetchFromGitHub {
    owner = "c-cube";
    repo = "ocaml-containers";
    rev = "v${version}";
    sha256 = "1nsxfgn1g1vpqihb9gd6gsab0bcm70nf9z84cp441c8wsc57hi6a";
  };

  buildInputs = [ iter ];

  checkInputs = lib.optionals doCheck [ gen mdx.bin ounit qcheck uutf ];

  propagatedBuildInputs = [ result uchar ];

  doCheck = true;

  meta = {
    homepage = https://github.com/c-cube/ocaml-containers;
    description = "A modular standard library focused on data structures";
    longDescription = ''
      Containers is a standard library (BSD license) focused on data structures,
      combinators and iterators, without dependencies on unix. Every module is
      independent and is prefixed with 'CC' in the global namespace. Some modules
      extend the stdlib (e.g. CCList provides safe map/fold_right/append, and
      additional functions on lists).

      It also features optional libraries for dealing with strings, and
      helpers for unix and threads.
    '';
    license = lib.licenses.bsd2;
  };
}

{ lib, fetchFromGitHub, buildDunePackage, ocaml
, dune-configurator
, either, seq
, gen, iter, ounit, qcheck, uutf
}:

buildDunePackage rec {
  version = "3.6.1";
  pname = "containers";

  useDune2 = true;

  src = fetchFromGitHub {
    owner = "c-cube";
    repo = "ocaml-containers";
    rev = "v${version}";
    sha256 = "sha256:1k8xrs3nki8g875sig9f5v6k4vwxrk5gn7ixrlkkys5ksbr4kis7";
  };

  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [ either seq ];

  checkInputs = [ gen iter ounit qcheck uutf ];

  doCheck = lib.versionAtLeast ocaml.version "4.08";

  meta = {
    homepage = "https://github.com/c-cube/ocaml-containers";
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

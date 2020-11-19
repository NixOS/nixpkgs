{ lib, fetchFromGitHub, buildDunePackage, ocaml
, seq
, gen, iter, ounit, qcheck, uutf
}:

buildDunePackage rec {
  version = "3.0";
  pname = "containers";

  src = fetchFromGitHub {
    owner = "c-cube";
    repo = "ocaml-containers";
    rev = "v${version}";
    sha256 = "0c75d5csgc68qqbsdz4279nlin111zrjbg4d47k32ska28myvpqn";
  };

  propagatedBuildInputs = [ seq ];

  checkInputs = [ gen iter ounit qcheck uutf ];

  doCheck = true;

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

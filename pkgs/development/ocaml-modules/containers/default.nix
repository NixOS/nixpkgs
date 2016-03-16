{ stdenv, fetchFromGitHub, ocaml, findlib, cppo, gen, sequence, qtest, ounit }:

let version = "0.15"; in

stdenv.mkDerivation {
  name = "ocaml-containers-${version}";

  src = fetchFromGitHub {
    owner = "c-cube";
    repo = "ocaml-containers";
    rev = "${version}";
    sha256 = "13mdl8jp4ymg1wip7lqmh4224x4jnji3frm1ik55vvm3ac8caqng";
  };

  buildInputs = [ ocaml findlib cppo gen sequence qtest ounit ];

  configureFlags = [
    "--enable-unix"
    "--enable-thread"
    "--enable-bigarray"
    "--enable-advanced"
    "--enable-tests"
    "--disable-bench"
  ];

  doCheck = true;
  checkTarget = "test";

  createFindlibDestdir = true;

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
    license = stdenv.lib.licenses.bsd2;
    platforms = ocaml.meta.platforms;
    hydraPlatforms = ocaml.meta.hydraPlatforms;
  };
}

{
  lib,
  fetchFromGitHub,
  buildDunePackage,
  ocaml,
  dune-configurator,
  either,
  seq,
  gen,
  iter,
  qcheck-core,
  uutf,
  yojson,
}:

buildDunePackage rec {
  version = "3.15";
  pname = "containers";

  minimalOCamlVersion = "4.08";

  src = fetchFromGitHub {
    owner = "c-cube";
    repo = "ocaml-containers";
    rev = "v${version}";
    hash = "sha256-PMtyJOuw+9u6rF5EGif/66ZSbkTu1Msgke9JVpDWC1c=";
  };

  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [
    either
    seq
  ];

  checkInputs = [
    gen
    iter
    qcheck-core
    uutf
    yojson
  ];

  doCheck = lib.versionAtLeast ocaml.version "4.08";

  meta = {
    homepage = "https://github.com/c-cube/ocaml-containers";
    description = "Modular standard library focused on data structures";
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

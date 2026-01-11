{
  lib,
  fetchFromGitHub,
  fetchpatch,
  buildDunePackage,
  dune-configurator,
  either,
  seq,
  gen,
  iter,
  qcheck-core,
  uutf,
  yojson,
}:

buildDunePackage (finalAttrs: {
  version = "3.16";
  pname = "containers";

  src = fetchFromGitHub {
    owner = "c-cube";
    repo = "ocaml-containers";
    rev = "v${finalAttrs.version}";
    hash = "sha256-WaHAZRLjaEJUba/I2r3Yof/iUqA3PFUuVbzm88izG1k=";
  };

  patches = [
    # Compatibility with qcheck ≥ 0.26
    (fetchpatch {
      url = "https://github.com/c-cube/ocaml-containers/commit/3b49ad2a4e8cfe366d0588e1940d626f0e1b8a2d.patch";
      hash = "sha256-LFe+LtpBBrf82SX57b4iQSvfd9tSXmnfhffjvjcfLpg=";
    })
  ];

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

  doCheck = true;

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
})

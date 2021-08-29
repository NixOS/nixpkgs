{ lib, fetchFromGitHub, buildDunePackage, ocaml, dune-configurator
, mdx, qtest, result
}:

buildDunePackage rec {
  pname = "iter";
  version = "1.2.1";

  useDune2 = true;

  src = fetchFromGitHub {
    owner = "c-cube";
    repo = pname;
    rev = version;
    sha256 = "0j2sg50byn0ppmf6l36ksip7zx1d3gv7sc4hbbxs2rmx39jr7vxh";
  };

  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [ result ];

  doCheck = lib.versionAtLeast ocaml.version "4.07";
  checkInputs = [ mdx.bin qtest ];

  meta = {
    homepage = "https://github.com/c-cube/sequence";
    description = "Simple sequence (iterator) datatype and combinators";
    longDescription = ''
      Simple sequence datatype, intended to transfer a finite number of
      elements from one data structure to another. Some transformations on sequences,
      like `filter`, `map`, `take`, `drop` and `append` can be performed before the
      sequence is iterated/folded on.
    '';
    license = lib.licenses.bsd2;
  };
}

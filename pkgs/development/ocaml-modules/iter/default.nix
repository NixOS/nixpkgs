{ lib, fetchFromGitHub, buildDunePackage, ocaml, dune-configurator
, result, seq
, mdx, ounit2, qcheck-core
}:

buildDunePackage rec {
  pname = "iter";
  version = "1.6";

  duneVersion = "3";

  src = fetchFromGitHub {
    owner = "c-cube";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-FbM/Vk/h4wkrBjyf9/QXTvTOA0nNqsdHP1mDnVkg1is=";
  };

  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [ result seq ];

  doCheck = lib.versionAtLeast ocaml.version "4.08";
  nativeCheckInputs = [ mdx.bin ];
  checkInputs = [ ounit2 qcheck-core ];

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

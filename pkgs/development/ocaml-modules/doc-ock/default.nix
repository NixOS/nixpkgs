{ stdenv, fetchFromGitHub, buildDunePackage, octavius, cppo }:

buildDunePackage rec {
  pname = "doc-ock";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "ocaml-doc";
    repo = pname;
    rev = "v${version}";
    sha256 = "090vprm12jrl55yllk1hdzbsqyr107yjs2qnc49yahdhvnr4h5b7";
  };

  buildInputs = [ cppo ];

  propagatedBuildInputs = [ octavius ];

  meta = {
    description = "Extract documentation from OCaml files";
    license = stdenv.lib.licenses.isc;
    maintainers = [ stdenv.lib.maintainers.vbgl ];
    inherit (src.meta) homepage;
  };
}

{ fetchFromGitHub, findlib, lib, ocaml, result, stdenv }:

stdenv.mkDerivation rec {
  pname = "ocaml${ocaml.version}-stb-image";
  version = "unstable-2020-12-25";

  src = fetchFromGitHub {
    owner = "let-def";
    repo = "stb_image";
    rev = "544d812e0074438a78a3e88faf6ff176198d779a";
    sha256 = "sha256-grwZuNS8D/qPskLBJFMfsNiGVX86BTVHdTdbDbwcoko=";
  };

  nativeBuildInputs = [ ocaml findlib ];

  buildInputs = [ result ];

  preInstall = ''
    mkdir -p $out/lib/ocaml/${ocaml.version}/site-lib/stublibs
  '';

  meta = with lib; {
    description = "OCaml bindings to stb_image, a public domain image loader";
    homepage = "https://github.com/let-def/stb_image";
    maintainers = with maintainers; [ superherointj ];
    license = licenses.cc0;
  };
}

{ stdenv, fetchFromGitHub, ocaml, findlib, ocamlbuild, ctypes, libsodium }:

stdenv.mkDerivation rec {
  pname = "ocaml${ocaml.version}-sodium";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner  = "dsheets";
    repo   = "ocaml-sodium";
    rev    = version;
    sha256 = "124gpi1jhac46x05gp5viykyrafnlp03v1cmkl13c6pgcs8w04pv";
  };

  buildInputs = [ ocaml findlib ocamlbuild ];
  propagatedBuildInputs = [ ctypes libsodium ];

  createFindlibDestdir = true;

  hardeningDisable = stdenv.lib.optional stdenv.isDarwin "strictoverflow";

  meta = with stdenv.lib; {
    homepage = https://github.com/dsheets/ocaml-sodium;
    description = "Binding to libsodium 1.0.9+";
    platforms = ocaml.meta.platforms or [];
    maintainers = [ maintainers.rixed ];
  };
}

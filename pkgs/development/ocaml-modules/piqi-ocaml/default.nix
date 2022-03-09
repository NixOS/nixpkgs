{ lib, stdenv, fetchFromGitHub, fetchpatch, ocaml, findlib, piqi, stdlib-shims }:

stdenv.mkDerivation rec {
  version = "0.7.7";
  pname = "piqi-ocaml";
  name = "ocaml${ocaml.version}-${pname}-${version}";

  src = fetchFromGitHub {
    owner = "alavrik";
    repo = pname;
    rev = "v${version}";
    sha256 = "1913jpsb8mvqi8609j4g4sm5jhg50dq0xqxgy8nmvknfryyc89nm";
  };

  nativeBuildInputs = [ ocaml findlib ];
  buildInputs = [ piqi stdlib-shims ];

  strictDeps = true;

  createFindlibDestdir = true;

  installPhase = ''
    runHook preInstall
    DESTDIR=$out make install
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://piqi.org";
    description = "Universal schema language and a collection of tools built around it. These are the ocaml bindings";
    license = licenses.asl20;
    maintainers = [ maintainers.maurer ];
  };
}

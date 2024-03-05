{ stdenv
, fetchFromGitHub
, lib
, ncurses
, makeWrapper
, ocamlbuild
, findlib
, ocaml
, num
, zarith
}:

lib.throwIfNot (lib.versionAtLeast ocaml.version "4.07")
  "lem is not available for OCaml ${ocaml.version}"

stdenv.mkDerivation rec {
  pname = "ocaml${ocaml.version}-lem";
  version = "2022-12-10";

  src = fetchFromGitHub {
    owner = "rems-project";
    repo = "lem";
    rev = version;
    hash = "sha256-ZQgcuIVRkJS0KtpzjbO4OPHGg6B0TadWA6XpRir30y8=";
  };

  nativeBuildInputs = [ makeWrapper ocamlbuild findlib ocaml ];
  propagatedBuildInputs = [ zarith num ];

  installFlags = [ "INSTALL_DIR=$(out)" ];

  createFindlibDestdir = true;

  postInstall = ''
    wrapProgram $out/bin/lem --set LEMLIB $out/share/lem/library
  '';

  meta = with lib; {
    homepage = "https://github.com/rems-project/lem";
    description = "A tool for lightweight executable mathematics";
    maintainers = with maintainers; [ genericnerdyusername ];
    license = with licenses; [ bsd3 gpl2 ];
    platforms = ocaml.meta.platforms;
  };
}

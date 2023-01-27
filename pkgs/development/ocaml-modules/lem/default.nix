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

stdenv.mkDerivation rec {
  pname = "lem";
  version = "2022-12-10";

  minimalOCamlVersion = "4.07";

  nativeBuildInputs = [ makeWrapper ocamlbuild findlib ocaml ];
  buildInputs = [ ncurses num ];
  propagatedBuildInputs = [ zarith ];

  installFlags = "INSTALL_DIR=$(out)";

  preInstall = "mkdir -p $OCAMLFIND_DESTDIR";
  postInstall = ''
    mv $out/bin/lem $out/bin/.lem_wrapped
    makeWrapper $out/bin/.lem_wrapped $out/bin/lem --set LEMLIB $out/share/lem/library
  '';

  src = fetchFromGitHub {
    owner = "rems-project";
    repo = pname;
    rev = version;
    hash = "sha256-ZQgcuIVRkJS0KtpzjbO4OPHGg6B0TadWA6XpRir30y8=";
  };


  meta = with lib; {
    homepage = "https://github.com/rems-project/lem";
    description = "A tool for lightweight executable mathematics";
    maintainers = with maintainers; [ genericnerdyusername ];
    license = with licenses; [ bsd3 gpl2 ];
  };
}

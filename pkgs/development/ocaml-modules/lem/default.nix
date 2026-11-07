{
  stdenv,
  fetchFromGitHub,
  lib,
  makeWrapper,
  ocamlbuild,
  findlib,
  ocaml,
  num,
  zarith,
}:

stdenv.mkDerivation rec {
  pname = "ocaml${ocaml.version}-lem";
  version = "2026-05-01";

  src = fetchFromGitHub {
    owner = "rems-project";
    repo = "lem";
    rev = version;
    hash = "sha256-nIxx2fWst4nTOon+fEy4DOWefjZs62qb6/8ywnwn+vE=";
  };

  nativeBuildInputs = [
    makeWrapper
    ocamlbuild
    findlib
    ocaml
  ];
  propagatedBuildInputs = [
    zarith
    num
  ];

  installFlags = [ "INSTALL_DIR=$(out)" ];

  createFindlibDestdir = true;

  postInstall = ''
    wrapProgram $out/bin/lem --set LEMLIB $out/share/lem/library
  '';

  meta = {
    homepage = "https://github.com/rems-project/lem";
    description = "Tool for lightweight executable mathematics";
    mainProgram = "lem";
    maintainers = [ ];
    license = with lib.licenses; [
      bsd3
      gpl2
    ];
    platforms = ocaml.meta.platforms;
    broken = !(lib.versionAtLeast ocaml.version "4.07");
  };
}

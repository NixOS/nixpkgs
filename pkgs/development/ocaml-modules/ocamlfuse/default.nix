{ lib, buildDunePackage, fetchFromGitHub, camlidl, fuse, dune-configurator }:

buildDunePackage rec {
  pname = "ocamlfuse";
  version = "2.7.1_cvs9";

  src = fetchFromGitHub {
    owner = "astrada";
    repo = "ocamlfuse";
    rev = "v${version}";
    hash = "sha256-cOObHUAYiI2mN1qjsxcK6kHAmawuaGQOUNHqWioIvjM=";
  };

  postPatch = ''
    substituteInPlace lib/Fuse_main.c \
      --replace-warn "<fuse_lowlevel.h>" "<fuse/fuse_lowlevel.h>"
  '';

  nativeBuildInputs = [ camlidl ];
  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [ camlidl fuse ];

  meta = {
    homepage = "https://sourceforge.net/projects/ocamlfuse";
    description = "OCaml bindings for FUSE";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ bennofs ];
  };
}

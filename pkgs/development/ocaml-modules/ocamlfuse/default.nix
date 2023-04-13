{ lib, buildDunePackage, fetchFromGitHub, camlidl, fuse, dune-configurator }:

buildDunePackage rec {
  pname = "ocamlfuse";
  version = "2.7.1_cvs7";

  src = fetchFromGitHub {
    owner = "astrada";
    repo = "ocamlfuse";
    rev = "v${version}";
    sha256 = "6nmPXZx38hBGlg+gV9nnlRpPfeSAqDj4zBPcjUNvTRo=";
  };

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

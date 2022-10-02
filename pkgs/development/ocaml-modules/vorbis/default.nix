{ lib, buildDunePackage, fetchFromGitHub, dune-configurator, ogg, libvorbis }:

buildDunePackage rec {
  pname = "vorbis";
  version = "0.8.0";

  useDune2 = true;

  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-vorbis";
    rev = "v${version}";
    sha256 = "1acy7yvf2y5dggzxw4vmrpdipakr98si3pw5kxw0mh7livn08al8";
  };

  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [ ogg libvorbis ];

  meta = with lib; {
    homepage = "https://github.com/savonet/ocaml-vorbis";
    description = "Bindings to libvorbis";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ dandellion ];
  };
}

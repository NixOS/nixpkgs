{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  dune-configurator,
  pkg-config,
  ogg,
  flac,
}:

buildDunePackage rec {
  pname = "flac";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-flac";
    rev = "v${version}";
    sha256 = "sha256-HRRQd//e6Eh2HuyO+U00ILu5FoBT9jf/nRJzDOie70A=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [
    ogg
    flac.dev
  ];

  meta = with lib; {
    homepage = "https://github.com/savonet/ocaml-flac";
    description = "Bindings for flac";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ dandellion ];
  };
}

{ lib, fetchFromGitHub, pkg-config, buildDunePackage, dune-configurator
, gtk3, cairo2
, camlp-streams
}:

buildDunePackage rec {
  version = "3.1.3";
  pname = "lablgtk3";

  minimalOCamlVersion = "4.05";

  src = fetchFromGitHub {
    owner = "garrigue";
    repo = "lablgtk";
    rev = version;
    sha256 = "sha256-1kXJP+tKudP3qfosTgZAQueNK46H9aLevEj6wxPKDWY=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ dune-configurator camlp-streams ];
  propagatedBuildInputs = [ gtk3 cairo2 ];

  meta = {
    description = "OCaml interface to GTK 3";
    homepage = "http://lablgtk.forge.ocamlcore.org/";
    license = lib.licenses.lgpl21;
    maintainers = [ lib.maintainers.vbgl ];
  };
}

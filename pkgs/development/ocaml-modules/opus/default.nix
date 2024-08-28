{ lib, buildDunePackage, fetchFromGitHub, dune-configurator, pkg-config, ogg, libopus }:

buildDunePackage rec {
  pname = "opus";
  version = "0.2.2";

  duneVersion = "3";

  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-opus";
    rev = "v${version}";
    hash = "sha256-Ghfqw/J1oLbTJpYJaiB5M79jaA6DACvyxBVE+NjnPkg=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [ ogg libopus.dev ];

  meta = with lib; {
    homepage = "https://github.com/savonet/ocaml-opus";
    description = "Bindings to libopus";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ dandellion ];
  };
}

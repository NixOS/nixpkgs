{ lib, buildDunePackage, fetchFromGitHub, dune-configurator, pkg-config, ogg, libopus }:

buildDunePackage rec {
  pname = "opus";
  version = "0.2.2";

  useDune2 = true;

  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-opus";
    rev = "v${version}";
    sha256 = "sha256-Ghfqw/J1oLbTJpYJaiB5M79jaA6DACvyxBVE+NjnPkg=";
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

{
  lib,
  cmake,
  rustPlatform,
  pkg-config,
  fetchFromGitHub,
  atk,
  gtk3,
  glib,
  openssl,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "whitebox_tools";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "jblindsay";
    repo = "whitebox-tools";
    rev = "v${version}";
    hash = "sha256-kvtfEEydwonoDux1VbAxqrF/Hf8Qh8mhprYnROGOC6g=";
  };

  cargoHash = "sha256-yQFGuhEGgkaa5N4uUIZ/0GFzP9CsPtiFet0hUppIQzQ=";

  buildInputs = [
    atk
    glib
    gtk3
    openssl
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://jblindsay.github.io/ghrg/WhiteboxTools/index.html";
    description = "Advanced geospatial data analysis platform";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mpickering ];
    teams = [ lib.teams.geospatial ];
  };
}

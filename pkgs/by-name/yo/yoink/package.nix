{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

let
  version = "1.0.1";
in
buildGoModule {
  pname = "yoink";
  inherit version;

  src = fetchFromGitHub {
    owner = "MrMarble";
    repo = "yoink";
    rev = "v${version}";
    hash = "sha256-yI3koHVeZWkujpiO0qLj1i4m5l5BiZNZE5ix+IKFwyc=";
  };

  vendorHash = "sha256-P1bkugMaVKCvVx7y8g/elsEublHPA0SgeKzWiQCi4vs=";

  meta = {
    homepage = "https://github.com/MrMarble/yoink";
    description = "Automatically download freeleech torrents";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hogcycle ];
  };
}

{
  lib,
  fetchFromGitHub,
  fetchpatch,
  buildGoModule,
  pkg-config,
  libappindicator-gtk3,
}:

buildGoModule rec {
  pname = "syncthing-tray";
  version = "0.7";

  src = fetchFromGitHub {
    owner = "alex2108";
    repo = "syncthing-tray";
    rev = "v${version}";
    hash = "sha256-g/seDpNdoJ1tc5CTh2EuXoeo8XNpa9CaR+s7bW2cySA=";
  };

  vendorHash = "sha256-hGV5bivDUFEbOwU9sU+Eu5Wzz/aZtj6NUkpzHlmZTtw=";

  patches = [
    # Migrate to Go modules
    (fetchpatch {
      url = "https://github.com/alex2108/syncthing-tray/commit/94fac974a227cd03c566f81797a21b1bcc29adf5.patch";
      hash = "sha256-uJfnI9kGIlw4OzFoML+ulgR3keOeVB3+ox/4RtYJNXY=";
    })
  ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libappindicator-gtk3 ];

  meta = {
    description = "Simple application tray for syncthing";
    homepage = "https://github.com/alex2108/syncthing-tray";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      luftmensch-luftmensch
      nickhu
    ];
    mainProgram = "syncthing-tray";
  };
}

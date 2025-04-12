{
  fetchFromGitHub,
  installShellFiles,
  lib,
  rustPlatform,
  scdoc,
}:

rustPlatform.buildRustPackage rec {
  pname = "uair";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "metent";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-s6st4rBuviH1DACui3dakRt90z3TphIS4ptMN3eHpr8=";
  };

  cargoHash = "sha256-n7Kaha22Rh/5AGoHUiAxnaZvHtZ+rPsmLHiUYfA0YPE=";

  nativeBuildInputs = [
    installShellFiles
    scdoc
  ];

  preFixup = ''
    scdoc < docs/uair.1.scd > docs/uair.1
    scdoc < docs/uair.5.scd > docs/uair.5
    scdoc < docs/uairctl.1.scd > docs/uairctl.1

    installManPage docs/*.[1-9]
  '';

  meta = with lib; {
    description = "Extensible pomodoro timer";
    homepage = "https://github.com/metent/uair";
    license = licenses.mit;
    maintainers = with maintainers; [ thled ];
  };
}

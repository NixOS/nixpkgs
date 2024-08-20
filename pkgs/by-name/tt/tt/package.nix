{
  lib,
  fetchFromGitHub,
  buildGoModule,
  installShellFiles,
}:

buildGoModule rec {
  pname = "tt";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "lemnos";
    repo = "tt";
    rev = "v${version}";
    hash = "sha256-vKh19xYBeNqvVFilvA7NeQ34RM5VnwDs+Hu/pe3J0y4=";
  };

  vendorHash = "sha256-edY2CcZXOIed0+7IA8kr4lAfuSJx/nHtmc734XzT4z4=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
      mv $out/bin/src $out/bin/tt
      installManPage tt.1.gz
  '';

  meta = {
    description = "Typing test in the terminal written in Go";
    homepage = "https://github.com/lemnos/tt";
    license = lib.licenses.mit;
    mainProgram = "tt";
    maintainers = with lib.maintainers; [ vinetos ];
  };
}

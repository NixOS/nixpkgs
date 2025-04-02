{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "trawl";
  version = "0.2.5";

  src = fetchFromGitHub {
    owner = "sandptel";
    repo = "trawl";
    rev = "derivation";
    hash = "sha256-/nUvV0tgPzOJ5L+EXw6J/1lgRT+BPnlkv7yzko15o6A";
  };

  cargoHash = "sha256-TXdqphvt55PkTiXXjftSRkoMyEyBW0x0csjNPruYtoo=";

  useFetchCargoVendor = true;

  postInstall = ''
    install -Dm644 trawld/trawld.service $out/lib/systemd/user/trawld.service
  '';

  meta = {
    description = "Simple Xresources style linux based configuration system that is independent of distro / display backend (Wayland / X11 / etc)";
    homepage = "https://github.com/regolith-linux/trawl";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ sandptel ];
    platforms = lib.platforms.linux;
    mainProgram = "trawld";
  };
}

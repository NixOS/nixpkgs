{
  fetchFromGitHub,
  lib,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "systemd-manager-tui";
<<<<<<< HEAD
  version = "1.2.0";
=======
  version = "1.1.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "Matheus-git";
    repo = "systemd-manager-tui";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-/KtvQBye5Z7xfCO57YhM/s+XOAT4ZIBU6Ycu398haXw=";
  };

  cargoHash = "sha256-g6ES+A73E6k/TPw73azeYXj5R91Y98Im1enYKDqKTVk=";
=======
    hash = "sha256-rZ0Xz3TLklyo+HymYlM9RjKxp3Rv4OH9Vj/+sRYvfco=";
  };

  cargoHash = "sha256-38IKHIYMDS8GFxC6NTFA6hIipjAa4rpNHeZwd2+lfqU=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  meta = {
    homepage = "https://github.com/Matheus-git/systemd-manager-tui";
    description = "Program for managing systemd services through a TUI";
    mainProgram = "systemd-manager-tui";
    platforms = lib.platforms.linux;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ vuimuich ];
  };
})

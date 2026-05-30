{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "zsh-artisan";
  version = "0.0.0-unstable-2025-12-08";

  src = fetchFromGitHub {
    owner = "jessarcher";
    repo = "zsh-artisan";
    rev = "4063d53fd310f715c7a8fb7d4e133812ef0b3128";
    hash = "sha256-O0Tn9zQWR0i7UWJ9VtOvxjqpqz9Sj7aKogdHZSOATC0=";
  };

  __structuredAttrs = true;
  strictDeps = true;
  installPhase = ''
    install -D artisan.plugin.zsh --target-directory=$out/share/zsh-artisan
  '';

  meta = {
    description = "Laravel artisan plugin for zsh";
    longDescription = ''
      Laravel artisan plugin for zsh to help you to run artisan from anywhere in the project tree,
      with auto-completion, and it can automatically open files created by artisan!
    '';
    homepage = "https://github.com/jessarcher/zsh-artisan";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.FatBoyXPC ];
  };
}

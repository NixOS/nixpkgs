{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zsh-completions";
  version = "0.36.0";

  src = fetchFromGitHub {
    owner = "zsh-users";
    repo = "zsh-completions";
    rev = finalAttrs.version;
    sha256 = "sha256-XCSC7DyhfnxzKjtbdsu7/pyw8eoVLPdthEoFZ8rBAyo=";
  };

  strictDeps = true;
  installPhase = ''
    install -D --target-directory=$out/share/zsh/site-functions src/*

    # tmuxp install it so avoid collision
    rm $out/share/zsh/site-functions/_tmuxp
  '';

  meta = {
    description = "Additional completion definitions for zsh";
    homepage = "https://github.com/zsh-users/zsh-completions";
    license = with lib.licenses; [
      asl20
      bsd3
      isc
      mit
      mit-modern
    ];
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.olejorgenb ];
  };
})

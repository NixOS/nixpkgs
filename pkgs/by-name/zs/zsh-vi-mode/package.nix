{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "zsh-vi-mode";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "jeffreytse";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-xbchXJTFWeABTwq6h4KWLh+EvydDrDzcY9AQVK65RS8=";
  };

  strictDeps = true;
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/share/${pname}
    cp *.zsh $out/share/${pname}/
  '';

  meta = {
    homepage = "https://github.com/jeffreytse/zsh-vi-mode";
    license = lib.licenses.mit;
    description = "Better and friendly vi(vim) mode plugin for ZSH";
    maintainers = with lib.maintainers; [ kyleondy ];
    platforms = lib.platforms.all;
  };
}

{ stdenv
, fetchFromGitHub
, lib
}:

stdenv.mkDerivation rec {
  pname = "nerdfonts-patcher-unwrapped";
  version = "v2.1.0";

  # This repo is approximately 2.2GB in size, and the font patcher isn't available separately
  # see this issue: https://github.com/ryanoasis/nerd-fonts/issues/484
  # The fork mentioned in the issue could be used, but I don't know how updated it is and will be.
  src = fetchFromGitHub {
    owner = "ryanoasis";
    repo = "nerd-fonts";
    rev = version;
    sha256 = "sha256-j0cLZHOLyoItdvLOQVQVurY3ARtndv0FZTynaYJPR9E=";
  };

  # Only install what we actually need (font-patcher and src/glyphs/*)
  installPhase = ''
    mkdir -p $out
    cp font-patcher $out
    mkdir -p $out/src/glyphs
    cp src/glyphs/* $out/src/glyphs/
  '';

  meta = with lib; {
    description = "Iconic font aggregator, collection, & patcher. 3,600+ icons, 50+ patched fonts";
    longDescription = ''
      Nerd Fonts is a project that attempts to patch as many developer targeted
      and/or used fonts as possible. The patch is to specifically add a high
      number of additional glyphs from popular 'iconic fonts' such as Font
      Awesome, Devicons, Octicons, and others.
    '';
    homepage = "https://nerdfonts.com/";
    license = licenses.mit;
    maintainers = with maintainers; [
      nomisiv
    ];
  };
}

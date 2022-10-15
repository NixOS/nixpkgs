{ stdenv, lib, fetchzip }:

stdenv.mkDerivation rec {
  pname = "fira-code";
  version = "6.2";
  src = fetchzip {
    url = "https://github.com/tonsky/FiraCode/releases/download/${version}/Fira_Code_v${version}.zip";
    stripRoot = false;
    sha256 = "sha256-UHOwZL9WpCHk6vZaqI/XfkZogKgycs5lWg1p0XdQt0A=";
  };

  # extract both static and variable fonts because
  # programs like VS Code don't load the variable version of Fira Code *Retina*
  # without fiddling.
  installPhase = ''
    source $stdenv/setup
    dst="$out/share/fonts/truetype"
    mkdir -p $dst
    cp $src/ttf/* $src/variable_ttf/* $dst/
  '';

  meta = with lib; {
    homepage = "https://github.com/tonsky/FiraCode";
    description = "Monospace font with programming ligatures";
    longDescription = ''
      Fira Code is a monospace font extending the Fira Mono font with
      a set of ligatures for common programming multi-character
      combinations.
    '';
    license = licenses.ofl;
    maintainers = [ maintainers.rycee maintainers.jayesh-bhoot ];
    platforms = platforms.all;
  };
}

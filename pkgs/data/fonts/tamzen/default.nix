{ fetchFromGitHub, mkfontscale, stdenv }:

stdenv.mkDerivation rec {
  pname = "tamzen-font";
  version = "1.11.5";

  src = fetchFromGitHub {
    owner = "sunaku";
    repo = "tamzen-font";
    rev = "Tamzen-${version}";
    sha256 = "00x5fipzqimglvshhqwycdhaqslbvn3rl06jnswhyxfvz16ymj7s";
  };

  nativeBuildInputs = [ mkfontscale ];

  installPhase = ''
    install -m 644 -D otb/*.otb pcf/*.pcf -t "$out/share/fonts/misc"
    install -m 644 -D psf/*.psf -t "$out/share/consolefonts"
    mkfontdir "$out/share/fonts/misc"
  '';

  meta = with stdenv.lib; {
    description = "Bitmapped programming font based on Tamsyn";
    longDescription = ''
    Tamzen is a monospace bitmap font. It is programatically forked
    from Tamsyn version 1.11, which backports glyphs from older
    versions while deleting deliberately empty glyphs to allow
    secondary/fallback fonts to provide real glyphs at those codepoints.
    Tamzen also has fonts that additionally provide the Powerline
    symbols.
    '';
    homepage = "https://github.com/sunaku/tamzen-font";
    license = licenses.free;
    maintainers = with maintainers; [ wishfort36 ];
  };
}


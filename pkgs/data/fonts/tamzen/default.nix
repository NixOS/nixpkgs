{ lib, mkFont, fetchFromGitHub, mkfontscale }:

mkFont rec {
  pname = "tamzen-font";
  version = "1.11.5";

  src = fetchFromGitHub {
    owner = "sunaku";
    repo = "tamzen-font";
    rev = "Tamzen-${version}";
    sha256 = "00x5fipzqimglvshhqwycdhaqslbvn3rl06jnswhyxfvz16ymj7s";
  };

  meta = with lib; {
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


{ fetchFromGitHub, fontforge, mkfontscale, stdenv }:

stdenv.mkDerivation rec {
  pname = "tamzen-font";
  version = "1.11.4";

  src = fetchFromGitHub {
    owner = "sunaku";
    repo = "tamzen-font";
    rev = "Tamzen-${version}";
    sha256 = "17kgmvg6q32mqhx9g44hjvzv0si0mnpprga4z7na930g2zdd8846";
  };

  nativeBuildInputs = [ fontforge mkfontscale ];

  installPhase = ''
    # convert pcf fonts to otb
    for i in pcf/*.pcf; do
      name=$(basename "$i" .pcf)
      fontforge -lang=ff -c "Open(\"$i\"); Generate(\"$name.otb\")"
    done

    install -m 644 -D pcf/*.pcf -t "$out/share/fonts/misc"
    install -m 644 -D psf/*.psf -t "$out/share/consolefonts"
    install -m 644 -D *.otb     -t "$otb/share/fonts/misc"
    mkfontdir "$out/share/fonts/misc"
    mkfontdir "$otb/share/fonts/misc"
  '';

  outputs = [ "out" "otb" ];

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


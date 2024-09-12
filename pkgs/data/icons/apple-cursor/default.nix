{ lib
, fetchzip
, stdenv
}:

let
  _src = variant: suffix: hash: fetchzip ({
    name = variant;
    url = "https://github.com/ful1e5/apple_cursor/releases/download/v${version}/${variant}.${suffix}";
    hash = hash;
  } // (lib.optionalAttrs (suffix == "zip") { stripRoot = false; }) // (lib.optionalAttrs (suffix == "tar.xz") { stripRoot = false; }));

  srcs = [
    (_src "macOS" "tar.xz" "sha256-nS4g+VwM+4q/S1ODb3ySi2SBk7Ha8vF8d9XpP5cEkok=")
  ];
  version = "2.0.1";
in stdenv.mkDerivation rec {
  pname = "apple_cursor";
  inherit version;
  inherit srcs;

  sourceRoot = ".";

  installPhase = ''
    install -dm 0755 $out/share/icons
    cp -r macOS/macOS* $out/share/icons/
  '';

  meta = with lib; {
    description = "Opensource macOS Cursors";
    homepage = "https://github.com/ful1e5/apple_cursor";
    license = [
      licenses.gpl3Only
      # Potentially a derivative work of copyrighted Apple designs
      licenses.unfree
    ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ colemickens dxwil ];
  };
}

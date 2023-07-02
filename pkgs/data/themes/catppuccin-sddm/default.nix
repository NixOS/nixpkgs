{ stdenv, lib, fetchFromGitHub, flavor ? "mocha" }:
stdenv.mkDerivation {
  pname = "sddm-catppuccin-theme";
  version = "unstable-2022-12-03";

  src = fetchFromGitHub {
    owner = "catppuccin";
    repo = "sddm";
    rev = "bde6932e1ae0f8fdda76eff5c81ea8d3b7d653c0";
    sha256 = "ceaK/I5lhFz6c+UafQyQVJIzzPxjmsscBgj8130D4dE=";
  };

  installPhase = ''
    mkdir -p $out/share/sddm/themes
    mv src/catppuccin-${flavor} $out/share/sddm/themes/catppuccin-${flavor}
  '';

  meta = {
    description = "Soothing pastel theme for SDDM";
    homepage = "https://github.com/catppuccin/sddm";
    maintainers = [ lib.maintainers.cobalt ];
    platforms = lib.platforms.linux;
    license = [ lib.licenses.mit ];
  };
}

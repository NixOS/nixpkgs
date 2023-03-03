lib: version: (removeAttrs (import ../meta.nix lib version) [ "maintainers" ]) // {
  platforms = lib.platforms.darwin;
  homepage = "https://www.azul.com/";
}

lib: (removeAttrs (import ../meta.nix lib) [ "maintainers" ]) // {
  platforms = lib.platforms.darwin;
  homepage = "https://www.azul.com/";
}

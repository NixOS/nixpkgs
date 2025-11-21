{
  qtModule,
  qtbase,
  qtdeclarative,
  qtsvg,
  hunspell,
  pkg-config,
}:

qtModule {
  pname = "qtvirtualkeyboard";
  propagatedBuildInputs = [
    qtbase
    qtdeclarative
    qtsvg
    hunspell
  ];
  nativeBuildInputs = [ pkg-config ];
  preBuild = ''
    # Max 4 cores as workaround for https://github.com/NixOS/nixpkgs/issues/463706
    NIX_BUILD_CORES=$(echo -ne "$NIX_BUILD_CORES\n4" | sort -n | head -1)
  '';
}

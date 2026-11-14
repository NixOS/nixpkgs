{
  swift,
  stdenv,
  tzdata,
}:

# Make sure Foundation reads the timezone database on NixOS. If it can’t find it, the process will crash.
stdenv.mkDerivation {
  name = "nixos-timezones";

  src = ./src;

  strictDeps = true;

  nativeBuildInputs = [ swift ];

  buildPhase = ''
    # SourceKit-LSP conveniently (or perhaps not for users) will crash if Foundation can’t find the timezone database.
    # Notes:
    # - TZ is set because the builds set TZ to `UTC` by default. When the timezone is UTC, Foundation will not try to
    #   read `zone.tab`, which is what leads to the crash when it is not found; and
    # - TZDIR is set because `/etc/zoneinfo` is not accessible in the build sandbox.
    TZDIR=${tzdata}/share/zoneinfo TZ=EST sourcekit-lsp debug index --project .
  '';

  installPhase = ''
    touch "$out"
  '';

  __structuredAttrs = true;
}

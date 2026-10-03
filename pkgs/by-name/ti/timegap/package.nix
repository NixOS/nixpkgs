{ lib, stdenv, fetchurl, meson, ninja }:

stdenv.mkDerivation (finalAttrs: {
  pname = "timegap";
  version = "8a822d4c21";

  src = fetchurl {
    url =
      "https://codeberg.org/sphi/timegap/archive/${finalAttrs.version}.tar.gz";
    hash = "sha256-aDLuxDWx5MIRJ7qIaJ5y4MYpToniy3xIvlISJtmBxUM=";
  };

  nativeBuildInputs = [ meson ninja ];

  meta = {
    description = ''
      A tool to add timestamps to output lines of an arbitrary program and/or
      display the duration of gaps between output lines.'';
    license = lib.licenses.mit;
    homepage = "https://codeberg.org/sphi/timegap";
    mainProgram = "tg";
    maintainers = with lib.maintainers; [ glittershark ];
  };
})

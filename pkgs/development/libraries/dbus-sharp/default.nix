{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  mono4,
  autoreconfHook,
}:

stdenv.mkDerivation rec {
  pname = "dbus-sharp";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "mono";
    repo = "dbus-sharp";

    rev = "v${version}";
    sha256 = "1g5lblrvkd0wnhfzp326by6n3a9mj2bj7a7646g0ziwgsxp5w6y7";
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];

  # Use msbuild when https://github.com/NixOS/nixpkgs/pull/43680 is merged
  # See: https://github.com/NixOS/nixpkgs/pull/46060
  buildInputs = [ mono4 ];

  dontStrip = true;

  meta = with lib; {
    description = "D-Bus for .NET";
    platforms = platforms.linux;
    license = licenses.mit;
  };
}

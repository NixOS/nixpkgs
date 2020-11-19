{ mkDerivation }:

# How to obtain `sha256`:
# nix-prefetch-url --unpack https://github.com/erlang/otp/archive/OTP-${version}.tar.gz
mkDerivation {
  version = "23.1.2";
  sha256 = "06dp2sw486khy2lc34cw5dca58ii5jvi26dpchiqxnmyvd6995z0";

  prePatch = ''
    substituteInPlace make/configure.in --replace '`sw_vers -productVersion`' "''${MACOSX_DEPLOYMENT_TARGET:-10.12}"
    substituteInPlace erts/configure.in --replace '-Wl,-no_weak_imports' ""
  '';
}

{stdenv, fetchurl, unzip, src, name, postInstall ? "true"}:

assert unzip != null;

stdenv.mkDerivation {
  inherit src name postInstall;
  setupHook = ./setup-hook.sh;
  builder = ./builder.sh;
  buildInputs = [unzip];
}

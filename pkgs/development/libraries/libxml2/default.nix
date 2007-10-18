{stdenv, fetchurl, zlib, python ? null, pythonSupport ? true}:

assert zlib != null;
assert pythonSupport -> python != null;

stdenv.mkDerivation {
  name = "libxml2-2.6.30";
  builder = ./builder.sh;

  src = fetchurl {
    url = ftp://xmlsoft.org/libxml2/libxml2-2.6.30.tar.gz;
    sha256 = "0pkk6cw0qd56kz2fkn768dcygbb4ncyvvmvyfiyli1a7yjh64xw7";
  };

  python = if pythonSupport then python else null;
  inherit pythonSupport zlib;

  buildInputs =  if pythonSupport then [python] else [];
  propagatedBuildInputs = [zlib];

  postInstall = "ensureDir $out/nix-support; cp ${./setup-hook.sh} $out/nix-support/setup-hook";
}

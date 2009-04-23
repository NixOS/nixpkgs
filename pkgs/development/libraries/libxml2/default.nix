{stdenv, fetchurl, zlib, python ? null, pythonSupport ? true}:

assert zlib != null;
assert pythonSupport -> python != null;

stdenv.mkDerivation ({
  name = "libxml2-2.6.32";
  builder = ./builder.sh;

  src = fetchurl {
    url = ftp://xmlsoft.org/libxml2/libxml2-2.6.32.tar.gz;
    sha256 = "0lsxr0akvp1sx29yh0nmzdhhc15dpa1i5chk40yaxjmgg6w2hi0v";
  };

  python = if pythonSupport then python else null;
  inherit pythonSupport zlib;

  buildInputs =  if pythonSupport then [python] else [];
  propagatedBuildInputs = [zlib];

  postInstall = "ensureDir $out/nix-support; cp ${./setup-hook.sh} $out/nix-support/setup-hook";
} // (if pythonSupport then {
  preConfigure = ''
    sed -e "s^pythondir=.*$^pythondir=$(toPythonPath $out)^" < configure.old > configure
  '';
} else {}))

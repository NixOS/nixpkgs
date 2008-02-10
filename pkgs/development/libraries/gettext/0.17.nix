args: with args;
stdenv.mkDerivation rec {
  name = "gettext-" + version;
  src = fetchurl {
    url = "mirror://gnu/gettext/${name}.tar.gz";
    sha256 = "1fipjpaxxwifdw6cbr7mkxp1yvy643i38nhlh7124bqnisxki5i0";
  };
  configureFlags = "--disable-csharp --enable-shared --disable-static";
}

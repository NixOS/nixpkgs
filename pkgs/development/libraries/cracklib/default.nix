{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "cracklib-2.8.12";
  builder = ./builder.sh;
  src = fetchurl {
    url = mirror://sourceforge/cracklib/cracklib-2.8.12.tar.gz;
    sha256 = "0l9kar7h80kkvs394dyzbn02jkd8hzynh9kxyqrlacj1wp35rmah";
  };
  dicts = fetchurl {
    url = http://nixos.org/tarballs/cracklib-words.gz;
    md5 = "d18e670e5df560a8745e1b4dede8f84f";
  };
}

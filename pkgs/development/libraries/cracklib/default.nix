{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "cracklib-2.8.13";

  builder = ./builder.sh;

  src = fetchurl {
    url = "mirror://sourceforge/cracklib/${name}.tar.gz";
    sha256 = "06h4b3hifsh1azpjvfn5qa052agavzz9xhgh4g89ghr66vzwl1ha";
  };

  dicts = fetchurl {
    url = http://nixos.org/tarballs/cracklib-words.gz;
    md5 = "d18e670e5df560a8745e1b4dede8f84f";
  };

  meta = {
    homepage = http://sourceforge.net/projects/cracklib;
    description = "A library for checking the strength of passwords";
  };
}

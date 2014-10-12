{ stdenv, fetchurl, python }:

stdenv.mkDerivation {
  name = "clearsilver-0.10.3";

  src = fetchurl {
    url = http://www.clearsilver.net/downloads/clearsilver-0.10.3.tar.gz;
    sha256 = "1lhbbf5rrqxb44y5clga7iifcfrh8sfjwpj4phnr3qabk92wdn3i";
  };

  builder = ./builder.sh;

  inherit stdenv python;

  meta = {
    description = "Fast, powerful, and language-neutral HTML template system";
    homepage = http://www.clearsilver.net/;
  };
}

{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  name = "libjson-7.4.0";
  src = fetchurl {
    url = "mirror://sourceforge/libjson/libjson_7.4.0.zip";
    sha256 = "0rd6m3r3acm7xq6f0mbyyhc3dnwmiga60cws29yjl6nx2f9h3r0x";
  };
  buildInputs = [ unzip ];
  makeFlags = "prefix=$out";
  meta = {
    homepage = "http://libjson.sourceforge.net/";
    description = "A JSON reader and writer";
    longDescription = "A JSON reader and writer which is super-effiecient and usually runs circles around other JSON libraries. It's highly customizable to optimize for your particular project, and very lightweight. For Windows, OSX, or Linux. Works in any language.";
  };
}

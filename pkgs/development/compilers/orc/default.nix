{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "orc-0.4.19";

  src = fetchurl {
    url = "http://gstreamer.freedesktop.org/src/orc/${name}.tar.gz";
    sha256 = "17mmgwll2waz44m908lcxc5fd6n44yysh7p4pdw33hr138r507z2";
  };

  doCheck = true;

  meta = {
    description = "The Oil Runtime Compiler";
    homepage = "http://code.entropywave.com/orc/";
    # The source code implementing the Marsenne Twister algorithm is licensed
    # under the 3-clause BSD license. The rest is 2-clause BSD license.
    license = stdenv.lib.licenses.bsd3;
    platform = stdenv.lib.platforms.linux;
  };
}

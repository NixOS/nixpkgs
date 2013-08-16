{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "orc-0.4.17";

  src = fetchurl {
    url = "http://code.entropywave.com/download/orc/${name}.tar.gz";
    sha256 = "1s6psp8phrd1jmxz9j01cksh3q5xrm1bd3z7zqxg5zsrijjcrisg";
  };

  meta = {
    description = "The Oil Runtime Compiler";
    homepage = "http://code.entropywave.com/orc/";
    # The source code implementing the Marsenne Twister algorithm is licensed
    # under the 3-clause BSD license. The rest is 2-clause BSD license.
    license = stdenv.lib.licenses.bsd3;
    platform = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.iyzsong ];
  };
}

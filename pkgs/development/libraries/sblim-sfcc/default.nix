{ fetchgit, stdenv, autoconf, automake, libtool, curl }:

stdenv.mkDerivation rec {
  version = "2.2.9";
  name = "sblim-sfcc-${version}";

  src = fetchgit {
    url = "https://github.com/kkaempf/sblim-sfcc.git";
    rev = "f70fecb410a53531e4fe99d39cf81b581819cac9";
    sha256 = "1dlhjvi888kz3bq56n0f86f25ny48a18rm4rgb4rx04aimas3dvj";
  };

  preConfigure = "./autoconfiscate.sh";

  buildInputs = [ autoconf automake libtool curl ];

  meta = {
    description = "Small Footprint CIM Client Library";

    homepage = http://sourceforge.net/projects/sblim/;

    maintainers = [ stdenv.lib.maintainers.deepfire ];

    license = stdenv.lib.licenses.cpl10;

    platforms = stdenv.lib.platforms.gnu;  # arbitrary choice

    inherit version;
  };
}

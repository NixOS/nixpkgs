{ stdenv, fetchgit, cmake, zlib, libpng, bzip2, libusb, openssl }:

stdenv.mkDerivation {
  name = "xpwn-0.5.8git";

  src = fetchgit {
    url = "git://github.com/dborca/xpwn.git";
    rev = "4534da88d4e8a32cdc9da9b5326e2cc482c95ef0";
    sha256 =
      "1h1ak40fg5bym0hifpii9q2hqdp2m387cwfzb4bl6qq36xpkd6wv";
  };

  preConfigure = ''
    rm BUILD # otherwise `mkdir build` fails on case insensitive file systems
    sed -r -i \
      -e 's/(install.*TARGET.*DESTINATION )\.\)/\1bin)/' \
      -e 's!(install.*(FILE|DIR).*DESTINATION )([^)]*)!\1share/xpwn/\3!' \
      */CMakeLists.txt
    sed -i -e '/install/d' CMakeLists.txt
  '';

  buildInputs = [ cmake zlib libpng bzip2 libusb openssl ];

  meta = {
    homepage = "http://planetbeing.lighthouseapp.com/projects/15246-xpwn";
    description = "Custom NOR firmware loader/IPSW generator for the iPhone";
    license = stdenv.lib.licenses.gpl3Plus;
  };
}

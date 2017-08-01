{ fetchFromGitHub, fetchpatch, stdenv, autoconf, automake, libtool, pkgconfig
, libxml2, curl, cmake, pam, sblim-sfcc, python
}:

stdenv.mkDerivation rec {
  version = "2.6.3+git2017-04-20";
  name = "openwsman-${version}";

  src = fetchFromGitHub {
    owner = "Openwsman";
    repo = "openwsman";
    rev = "032d85704ac630d4c6bc59961867cd1428d3ab1e";
    sha256 = "sha256:1z8gsm213k5vsjg67smydm9f2m3jccayd2rjiik11prz0w8ixvig";
  };

  buildInputs = [ autoconf automake libtool pkgconfig libxml2 curl cmake pam sblim-sfcc python ];

  cmakeFlags = [
    "-DCMAKE_BUILD_RUBY_GEM=no"
  ];

  preConfigure = ''
    cmakeFlags="$cmakeFlags -DPACKAGE_ARCHITECTURE=$(uname -m)";
  '';

  configureFlags = "--disable-more-warnings";

  patches = [
    (fetchpatch {
      url = "https://github.com/Openwsman/openwsman/pull/99.patch";
      sha256 = "1dig0fm05qdfji5h7615g0yyvrdcvncwfqj94caqv8dzrpxi8ija";
    })
  ];

  meta = {
    description = "Openwsman server implementation and client api with bindings";
    homepage = https://github.com/Openwsman/openwsman;
    downloadPage = "https://github.com/Openwsman/openwsman/releases";
    maintainers = [ stdenv.lib.maintainers.deepfire ];
    license = stdenv.lib.licenses.bsd3;
    platforms = stdenv.lib.platforms.gnu;  # arbitrary choice
  };
}

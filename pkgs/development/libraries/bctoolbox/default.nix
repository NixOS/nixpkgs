{stdenv, fetchpatch, fetchFromGitHub, cmake, mbedtls, bcunit, srtp}:
stdenv.mkDerivation rec {
  name = "${baseName}-${version}";
  baseName = "bctoolbox";
  version = "0.6.0";
  nativeBuildInputs = [cmake];
  buildInputs = [mbedtls bcunit srtp];
  patches = [
    (fetchpatch {
      name = "fix-gcc9.patch";
      url = "https://github.com/BelledonneCommunications/bctoolbox/commit/2425a224634c7a70ae91f809bbab51771f0a30d7.patch";
      sha256 = "0ib859mwwlr6jk6qbwp6x25pp8wgv21lh0qgdsx5hyzwdzqx1b3h";
    })
  ];
  src = fetchFromGitHub {
    owner = "BelledonneCommunications";
    repo = baseName;
    rev = version;
    sha256 = "1cxx243wyzkd4xnvpyqf97n0rjhfckpvw1vhwnbwshq3q6fra909";
  };

  meta = {
    inherit version;
    description = ''Utilities library for Linphone'';
    license = stdenv.lib.licenses.gpl2Plus ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
  };
}

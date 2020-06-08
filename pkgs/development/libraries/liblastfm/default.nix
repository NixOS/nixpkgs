{ stdenv, fetchurl, pkgconfig, which, cmake
, fftwSinglePrec, libsamplerate, qtbase
, darwin }:

let version = "1.1.0"; in

stdenv.mkDerivation rec {
  pname = "liblastfm";
  inherit version;

  # Upstream does not package git tags as tarballs. Get tarball from github.
  src = fetchurl {
    url = "https://github.com/lastfm/liblastfm/tarball/${version}";
    name = "${pname}-${version}.tar.gz";
    sha256 = "1j34xc30vg7sfszm2jx9mlz9hy7p1l929fka9wnfcpbib8gfi43x";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace 'find_package(Qt5Core QUIET)' \
                'find_package(Qt5 REQUIRED COMPONENTS Core Network Sql Test Xml)'
  '';

  prefixKey = "--prefix ";
  nativeBuildInputs = [ pkgconfig which cmake ];
  buildInputs = [ fftwSinglePrec libsamplerate qtbase ]
    ++ stdenv.lib.optional stdenv.isDarwin darwin.apple_sdk.frameworks.SystemConfiguration;

  meta = with stdenv.lib; {
    homepage = "https://github.com/lastfm/liblastfm";
    repositories.git = "git://github.com/lastfm/liblastfm.git";
    description = "Official LastFM library";
    platforms = platforms.unix;
    maintainers =  [ maintainers.phreedom ];
    license = licenses.gpl3;
  };
}

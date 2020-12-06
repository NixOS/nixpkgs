{ stdenv, fetchFromGitHub, fetchpatch, pkgconfig, which, cmake
, fftwSinglePrec, libsamplerate, qtbase
, darwin }:

stdenv.mkDerivation rec {
  pname = "liblastfm-unstable";
  version = "2019-08-23";

  src = fetchFromGitHub {
    owner = "lastfm";
    repo = "liblastfm";
    rev = "2ce2bfe1879227af8ffafddb82b218faff813db9";
    sha256 = "1crih9xxf3rb109aqw12bjqv47z28lvlk2dpvyym5shf82nz6yd0";
  };

  patches = [(fetchpatch {
    url = "https://github.com/lastfm/liblastfm/commit/9c5d072b55f2863310e40291677e6397e9cbc3c2.patch";
    name = "0001-Remove-deprecated-staging-server-and-fix-test-for-QT5-at-Ubuntu-19.10.patch";
    sha256 = "04r14prydxshjgfws3pjajjmp2msszhjjs1mjh8s66yg29vq620l";
  })];

  nativeBuildInputs = [ pkgconfig which cmake ];
  buildInputs = [ fftwSinglePrec libsamplerate qtbase ]
    ++ stdenv.lib.optional stdenv.isDarwin darwin.apple_sdk.frameworks.SystemConfiguration;

  meta = with stdenv.lib; {
    homepage = "https://github.com/lastfm/liblastfm";
    repositories.git = "git://github.com/lastfm/liblastfm.git";
    description = "Official LastFM library";
    platforms = platforms.unix;
    maintainers = [ maintainers.phreedom ];
    license = licenses.gpl3;
  };
}

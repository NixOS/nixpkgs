{ stdenv, fetchFromGitHub, pkgconfig, cmake, zlib, fetchpatch
, dbus, networkmanager, spidermonkey_38, pcre, python2, python3
, SystemConfiguration, CoreFoundation, JavaScriptCore }:

stdenv.mkDerivation rec {
  name = "libproxy-${version}";
  version = "0.4.15";

  src = fetchFromGitHub {
    owner = "libproxy";
    repo = "libproxy";
    rev = version;
    sha256 = "10swd3x576pinx33iwsbd4h15fbh2snmfxzcmab4c56nb08qlbrs";
  };

  outputs = [ "out" "dev" ]; # to deal with propagatedBuildInputs

  nativeBuildInputs = [ pkgconfig cmake ];

  buildInputs = [ pcre python2 python3 zlib ]
        ++ (if stdenv.hostPlatform.isDarwin
            then [ SystemConfiguration CoreFoundation JavaScriptCore ]
            else [ spidermonkey_38 dbus networkmanager ]);

  preConfigure = ''
    cmakeFlagsArray+=(
      "-DWITH_MOZJS=ON"
      "-DPYTHON2_SITEPKG_DIR=$out/${python2.sitePackages}"
      "-DPYTHON3_SITEPKG_DIR=$out/${python3.sitePackages}"
    )
  '';

  patches = stdenv.lib.optional stdenv.isDarwin
    (fetchpatch {
      url = "https://github.com/libproxy/libproxy/commit/44158f03f8522116758d335688ed840dfcb50ac8.patch";
      sha256 = "0axfvb6j7gcys6fkwi9dkn006imhvm3kqr83gpwban8419n0q5v1";
    });

  doCheck = false; # fails 1 out of 10 tests

  meta = with stdenv.lib; {
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.lgpl21;
    homepage = http://libproxy.github.io/libproxy/;
    description = "A library that provides automatic proxy configuration management";
  };
}

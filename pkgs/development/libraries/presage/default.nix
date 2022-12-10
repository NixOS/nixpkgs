{ lib
, stdenv
, fetchurl
, fetchpatch
, autoreconfHook
, dbus
, doxygen
, fontconfig
, gettext
, graphviz
, help2man
, pkg-config
, sqlite
, tinyxml
, cppunit
}:

stdenv.mkDerivation rec {
  pname = "presage";
  version = "0.9.1";

  src = fetchurl {
    url = "mirror://sourceforge/presage/presage/${version}/presage-${version}.tar.gz";
    sha256 = "0rm3b3zaf6bd7hia0lr1wyvi1rrvxkn7hg05r5r1saj0a3ingmay";
  };

  patches = [
    (fetchpatch {
      url = "https://git.alpinelinux.org/aports/plain/community/presage/gcc6.patch";
      sha256 = "0243nx1ygggmsly7057vndb4pkjxg9rpay5gyqqrq9jjzjzh63dj";
    })
    ./fixed-cppunit-detection.patch
    # fix gcc11 build
    (fetchpatch {
      name = "presage-0.9.1-gcc11.patch";
      url = "https://build.opensuse.org/public/source/openSUSE:Factory/presage/presage-0.9.1-gcc11.patch?rev=3f8b4b19c99276296d6ea595cc6c431f";
      sha256 = "sha256-pLrIFXvJHRvv4x9gBIfal4Y68lByDE3XE2NZNiAXe9k=";
    })
  ];

  nativeBuildInputs = [
    autoreconfHook
    doxygen
    fontconfig
    gettext
    graphviz
    help2man
    pkg-config
  ];

  preBuild = ''
    export FONTCONFIG_FILE=${fontconfig.out}/etc/fonts/fonts.conf
  '';

  buildInputs = [
    dbus
    sqlite
    tinyxml
  ];

  checkInputs = [
    cppunit
  ];

  doCheck = true;

  checkTarget = "check";

  meta = with lib; {
    description = "An intelligent predictive text entry system";
    homepage = "https://presage.sourceforge.io/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ dotlambda ];
  };
}

{
  lib,
  stdenv,
  fetchurl,
  qtbase,
  qtsvg,
  qttools,
  qmake,
  fixDarwinDylibNames,
}:

stdenv.mkDerivation rec {
  pname = "qwt";
  version = "6.3.0";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "mirror://sourceforge/qwt/qwt-${version}.tar.bz2";
    sha256 = "sha256-3LCFiWwoquxVGMvAjA7itOYK2nrJKdgmOfYYmFGmEpo=";
  };

  patches = [
    # Fix the generated pkg-config file when built against Qt6.
    # The file wrongly pulled in an unsatisfied dependency to Qt5.
    #
    # When building Qwt using Qt6, the constructed pkgconfig .pc file was
    # previously set up to only look for Qt5 libraries. This fix now matches
    # the library dependency to the Qt version used in building Qwt.
    #
    # See upstream commit b225ea23753ce35356ad1b53c0854813004bb605.
    # https://sourceforge.net/p/qwt/git/ci/b225ea23753ce35356ad1b53c0854813004bb605/basic
    ./0001-pkgconfig-for-Qt-5-6-adjustments.patch
  ];

  propagatedBuildInputs = [
    qtbase
    qtsvg
    qttools
  ];
  nativeBuildInputs = [ qmake ] ++ lib.optional stdenv.hostPlatform.isDarwin fixDarwinDylibNames;

  postPatch = ''
    sed -e "s|QWT_INSTALL_PREFIX.*=.*|QWT_INSTALL_PREFIX = $out|g" -i qwtconfig.pri
  '';

  qmakeFlags = [ "-after doc.path=$out/share/doc/qwt-${version}" ];

  dontWrapQtApps = true;

  meta = {
    description = "Qt widgets for technical applications";
    homepage = "http://qwt.sourceforge.net/";
    # LGPL 2.1 plus a few exceptions (more liberal)
    license = with lib.licenses; [
      lgpl21Only
      qwtException
    ];
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.bjornfor ];
  };
}

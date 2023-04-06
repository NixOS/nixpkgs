{ lib, stdenv, fetchurl, pkg-config, glib, zlib, gnupg, gpgme, libidn2, libunistring, gobject-introspection
, vala
, gtk-doc
, autoreconfHook
}:

stdenv.mkDerivation rec {
  version = "3.2.12";
  pname = "gmime";

  src = fetchurl { # https://github.com/jstedfast/gmime/releases
    url = "https://github.com/jstedfast/gmime/releases/download/${version}/gmime-${version}.tar.xz";
    sha256 = "sha256-OPm3aBgjQsSExBIobbjVgRaX/4FiQ3wFea3w0G4icFs=";
  };

  outputs = [ "out" "dev" ];

  buildInputs = [ vala zlib gpgme libidn2 libunistring ];
  nativeBuildInputs = [ pkg-config autoreconfHook gobject-introspection gtk-doc libidn2 ];
  propagatedBuildInputs = [ glib ];
  configureFlags = lib.optionals (stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    "--enable-introspection=yes"
    "--enable-vala=yes"
  ] ++ lib.optionals (!(stdenv.buildPlatform.canExecute stdenv.hostPlatform)) [
    # from Void Linux commit 48ce73c6cca6bfbade802f513a7b19d4e18ed583
    "am_cv_func_iconv=yes"
    "am_cv_func_iconv_works=yes"
    "am_cv_lib_iconv=no"
    "ac_cv_have_iconv_detect_h=yes"
    "am_cv_proto_iconv_arg1="
    "--enable-vala=no"
  ];

  postPatch = ''
    substituteInPlace tests/testsuite.c \
      --replace /bin/rm rm
  ''
  # from Void Linux commit 48ce73c6cca6bfbade802f513a7b19d4e18ed583
  + lib.optionalString (!(stdenv.buildPlatform.canExecute stdenv.hostPlatform)) ''
    cp --no-preserve=all ${./iconv-detect.h} iconv-detect.h
  '';

  nativeCheckInputs = [ gnupg ];

  doCheck = true;

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://github.com/jstedfast/gmime/";
    description = "A C/C++ library for creating, editing and parsing MIME messages and structures";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
  };
}

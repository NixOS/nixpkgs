{ lib, stdenv
, fetchurl
, python3
, pkg-config
, cmocka
, readline
, talloc
, libxslt
, docbook-xsl-nons
, docbook_xml_dtd_42
, which
<<<<<<< HEAD
, waf
=======
, wafHook
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, libxcrypt
}:

stdenv.mkDerivation rec {
  pname = "tevent";
<<<<<<< HEAD
  version = "0.15.0";

  src = fetchurl {
    url = "mirror://samba/tevent/${pname}-${version}.tar.gz";
    sha256 = "sha256-ZiqfJ3KBvPUGtrwKC6oD5EpiIpUW7jS8xwOguCqkaQU=";
=======
  version = "0.14.1";

  src = fetchurl {
    url = "mirror://samba/tevent/${pname}-${version}.tar.gz";
    sha256 = "sha256-74X8qoD/0jUQNrpLNHYw/vKhrD2pZKfxggRmutA80A0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    pkg-config
    which
    python3
    libxslt
    docbook-xsl-nons
    docbook_xml_dtd_42
<<<<<<< HEAD
    waf.hook
=======
    wafHook
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  buildInputs = [
    python3
    cmocka
    readline # required to build python
    talloc
    libxcrypt
  ];

  # otherwise the configure script fails with
  # PYTHONHASHSEED=1 missing! Don't use waf directly, use ./configure and make!
  preConfigure = ''
    export PKGCONFIG="$PKG_CONFIG"
    export PYTHONHASHSEED=1
  '';

  wafPath = "buildtools/bin/waf";

  wafConfigureFlags = [
    "--bundled-libraries=NONE"
    "--builtin-libraries=replace"
  ];

  # python-config from build Python gives incorrect values when cross-compiling.
  # If python-config is not found, the build falls back to using the sysconfig
  # module, which works correctly in all cases.
  PYTHON_CONFIG = "/invalid";

  meta = with lib; {
    description = "An event system based on the talloc memory management library";
    homepage = "https://tevent.samba.org/";
    license = licenses.lgpl3Plus;
    platforms = platforms.all;
  };
}

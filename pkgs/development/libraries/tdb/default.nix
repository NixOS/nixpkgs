{ lib, stdenv
, fetchurl
, pkg-config
, wafHook
, python3
, readline
, libxslt
, libxcrypt
, docbook-xsl-nons
, docbook_xml_dtd_45
}:

stdenv.mkDerivation rec {
  pname = "tdb";
  version = "1.4.8";

  src = fetchurl {
    url = "mirror://samba/tdb/${pname}-${version}.tar.gz";
    sha256 = "sha256-hDTJyFfRPOP6hGb3VgHyXDaTZ2s2kZ8VngrWEhuvXOg=";
  };

  nativeBuildInputs = [
    python3
    pkg-config
    wafHook
    libxslt
    docbook-xsl-nons
    docbook_xml_dtd_45
  ];

  buildInputs = [
    python3
    readline # required to build python
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
    description = "The trivial database";
    longDescription = ''
      TDB is a Trivial Database. In concept, it is very much like GDBM,
      and BSD's DB except that it allows multiple simultaneous writers
      and uses locking internally to keep writers from trampling on each
      other. TDB is also extremely small.
    '';
    homepage = "https://tdb.samba.org/";
    license = licenses.lgpl3Plus;
    platforms = platforms.all;
  };
}

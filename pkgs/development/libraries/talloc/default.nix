{ lib, stdenv
, fetchurl
, python3
, pkg-config
, readline
, libxslt
, libxcrypt
, docbook-xsl-nons
, docbook_xml_dtd_42
, fixDarwinDylibNames
, wafHook
}:

stdenv.mkDerivation rec {
  pname = "talloc";
  version = "2.4.0";

  src = fetchurl {
    url = "mirror://samba/talloc/${pname}-${version}.tar.gz";
    sha256 = "sha256-bfNoYsQkZu+I82BERROHDvRpNPkBbIQ4PMQAin0MRro=";
  };

  nativeBuildInputs = [
    pkg-config
    python3
    wafHook
    docbook-xsl-nons
    docbook_xml_dtd_42
  ] ++ lib.optionals stdenv.isDarwin [
    fixDarwinDylibNames
  ];

  buildInputs = [
    python3
    readline
    libxslt
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
    "--enable-talloc-compat1"
    "--bundled-libraries=NONE"
    "--builtin-libraries=replace"
  ];

  # python-config from build Python gives incorrect values when cross-compiling.
  # If python-config is not found, the build falls back to using the sysconfig
  # module, which works correctly in all cases.
  PYTHON_CONFIG = "/invalid";

  # this must not be exported before the ConfigurePhase otherwise waf whines
  preBuild = lib.optionalString stdenv.hostPlatform.isMusl ''
    export NIX_CFLAGS_LINK="-no-pie -shared";
  '';

  postInstall = ''
    ${stdenv.cc.targetPrefix}ar q $out/lib/libtalloc.a bin/default/talloc.c.[0-9]*.o
  '';

  meta = with lib; {
    description = "Hierarchical pool based memory allocator with destructors";
    homepage = "https://tdb.samba.org/";
    license = licenses.gpl3;
    platforms = platforms.all;
  };
}

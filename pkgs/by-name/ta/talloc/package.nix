{
  lib,
  stdenv,
  fetchurl,
  python3,
  pkg-config,
  readline,
  libxslt,
  libxcrypt,
  docbook-xsl-nons,
  docbook_xml_dtd_42,
  fixDarwinDylibNames,
  wafHook,
  buildPackages,
}:

stdenv.mkDerivation rec {
  pname = "talloc";
  version = "2.4.3";

  src = fetchurl {
    url = "mirror://samba/talloc/${pname}-${version}.tar.gz";
    sha256 = "sha256-3EbEC59GuzTdl/5B9Uiw6LJHt3qRhXZzPFKOg6vYVN0=";
  };

  nativeBuildInputs =
    [
      pkg-config
      python3
      wafHook
      docbook-xsl-nons
      docbook_xml_dtd_42
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
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

  wafConfigureFlags =
    [
      "--enable-talloc-compat1"
      "--bundled-libraries=NONE"
      "--builtin-libraries=replace"
    ]
    ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
      "--cross-compile"
      "--cross-execute=${stdenv.hostPlatform.emulator buildPackages}"
    ];

  # python-config from build Python gives incorrect values when cross-compiling.
  # If python-config is not found, the build falls back to using the sysconfig
  # module, which works correctly in all cases.
  PYTHON_CONFIG = "/invalid";

  # https://reviews.llvm.org/D135402
  NIX_LDFLAGS = lib.optional (
    stdenv.cc.bintools.isLLVM && lib.versionAtLeast stdenv.cc.bintools.version "17"
  ) "--undefined-version";

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
    maintainers = [ maintainers.matthiasbeyer ];
  };
}

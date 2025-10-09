{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  wafHook,
  buildPackages,
  python3,
  readline,
  libxslt,
  libxcrypt,
  docbook-xsl-nons,
  docbook_xml_dtd_45,
}:

let
  needsAnswers =
    stdenv.hostPlatform != stdenv.buildPlatform
    && !(stdenv.hostPlatform.emulatorAvailable buildPackages);
  answers =
    {
      # PYTHONHASHSEED=1 python3.9 ./buildtools/bin/waf configure --bundled-libraries=NONE --builtin-libraries=replace --cross-compile --cross-execute=' ' --cross-answers=answers
      x86_64-freebsd = ./answers-x86_64-freebsd;
    }
    .${stdenv.hostPlatform.system}
      or (throw "Need pre-generated answers file to compile for ${stdenv.hostPlatform.system}");
in

stdenv.mkDerivation rec {
  pname = "tdb";
  version = "1.4.14";

  src = fetchurl {
    url = "mirror://samba/tdb/${pname}-${version}.tar.gz";
    hash = "sha256-FE9AfULteg7BRwpA7xetQRM/6RC86GXdn+CE1JyQdSY=";
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
  ''
  + lib.optionalString needsAnswers ''
    cp ${answers} answers
    chmod +w answers
  '';

  wafPath = "buildtools/bin/waf";

  wafConfigureFlags = [
    "--bundled-libraries=NONE"
    "--builtin-libraries=replace"
  ]
  ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    "--cross-compile"
    (
      if (stdenv.hostPlatform.emulatorAvailable buildPackages) then
        "--cross-execute=${stdenv.hostPlatform.emulator buildPackages}"
      else
        "--cross-answers=answers"
    )
  ];

  postFixup =
    if stdenv.hostPlatform.isDarwin then
      ''install_name_tool -id $out/lib/libtdb.dylib $out/lib/libtdb.dylib''
    else
      null;

  # python-config from build Python gives incorrect values when cross-compiling.
  # If python-config is not found, the build falls back to using the sysconfig
  # module, which works correctly in all cases.
  PYTHON_CONFIG = "/invalid";

  # https://reviews.llvm.org/D135402
  NIX_LDFLAGS = lib.optional (
    stdenv.cc.bintools.isLLVM && lib.versionAtLeast stdenv.cc.bintools.version "17"
  ) "--undefined-version";

  meta = with lib; {
    description = "Trivial database";
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

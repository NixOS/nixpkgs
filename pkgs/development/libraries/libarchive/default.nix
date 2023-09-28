{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, acl
, attr
, autoreconfHook
, bzip2
, e2fsprogs
, lzo
, openssl
, pkg-config
, sharutils
, xz
, zlib
, zstd
# Optional but increases closure only negligibly. Also, while libxml2 builds
# fine on windows, libarchive has trouble linking windows things it depends on
# for some reason.
, xarSupport ? stdenv.hostPlatform.isUnix, libxml2

# for passthru.tests
, cmake
, nix
, samba
}:

assert xarSupport -> libxml2 != null;
stdenv.mkDerivation (finalAttrs: {
  pname = "libarchive";
  version = "3.7.2";

  src = fetchFromGitHub {
    owner = "libarchive";
    repo = "libarchive";
    rev = "v${finalAttrs.version}";
    hash = "sha256-p2JgJ/rvqaQ6yyXSh+ehScUH565ud5bQncl+lOnsWfc=";
  };

  patches = [
    # Pull fix for test failure on 32-bit systems:
    (fetchpatch {
      name = "32-bit-tests-fix.patch";
      url = "https://github.com/libarchive/libarchive/commit/3bd918d92f8c34ba12de9c6604d96f9e262a59fc.patch";
      hash = "sha256-RM3xFM6S2DkM5DJ0kAba8eLzEXuY5/7AaU06maHJ6rM=";
    })
  ];

  outputs = [ "out" "lib" "dev" ];

  postPatch = let
    skipTestPaths = [
      # test won't work in nix sandbox
      "libarchive/test/test_write_disk_perms.c"
      # the filesystem does not necessarily have sparse capabilities
      "libarchive/test/test_sparse_basic.c"
      # the filesystem does not necessarily have hardlink capabilities
      "libarchive/test/test_write_disk_hardlink.c"
      # access-time-related tests flakey on some systems
      "cpio/test/test_option_a.c"
      "cpio/test/test_option_t.c"
    ];
    removeTest = testPath: ''
      substituteInPlace Makefile.am --replace "${testPath}" ""
      rm "${testPath}"
    '';
  in ''
    substituteInPlace Makefile.am --replace '/bin/pwd' "$(type -P pwd)"

    ${lib.concatStringsSep "\n" (map removeTest skipTestPaths)}
  '';

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs =  [
    bzip2
    lzo
    openssl
    xz
    zlib
    zstd
  ] ++ lib.optional stdenv.hostPlatform.isUnix sharutils
    ++ lib.optionals stdenv.isLinux [ acl attr e2fsprogs ]
    ++ lib.optional xarSupport libxml2;

  # Without this, pkg-config-based dependencies are unhappy
  propagatedBuildInputs = lib.optionals stdenv.isLinux [ attr acl ];

  configureFlags = lib.optional (!xarSupport) "--without-xml2";

  preBuild = lib.optionalString stdenv.isCygwin ''
    echo "#include <windows.h>" >> config.h
  '';

  # https://github.com/libarchive/libarchive/issues/1475
  doCheck = !stdenv.hostPlatform.isMusl;

  preFixup = ''
    sed -i $lib/lib/libarchive.la \
      -e 's|-lcrypto|-L${lib.getLib openssl}/lib -lcrypto|' \
      -e 's|-llzo2|-L${lzo}/lib -llzo2|'
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "http://libarchive.org";
    description = "Multi-format archive and compression library";
    longDescription = ''
      The libarchive project develops a portable, efficient C library that can
      read and write streaming archives in a variety of formats. It also
      includes implementations of the common tar, cpio, and zcat command-line
      tools that use the libarchive library.
    '';
    changelog = "https://github.com/libarchive/libarchive/releases/tag/v${finalAttrs.version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jcumming AndersonTorres ];
    platforms = platforms.all;
  };

  passthru.tests = {
    inherit cmake nix samba;
  };
})

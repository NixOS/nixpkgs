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
    (fetchpatch {
      name = "fix-suspicious-commit-from-known-bad-actor.patch";
      url = "https://github.com/libarchive/libarchive/commit/6110e9c82d8ba830c3440f36b990483ceaaea52c.patch";
      hash = "sha256-/j6rJ0xWhtXU0YCu1LOokxxNppy5Of6Q0XyO4U6la7M=";
    })
    (fetchpatch {
      # https://github.com/advisories/GHSA-2jc9-36w4-pmqw
      name = "CVE-2024-26256.patch";
      url = "https://github.com/libarchive/libarchive/commit/eb7939b24a681a04648a59cdebd386b1e9dc9237.patch";
      hash = "sha256-w/WuOGlx5pSw4LwMgvL6arrL1Huhg45bitoRRVEHcec=";
    })
    (fetchpatch {
      # https://github.com/libarchive/libarchive/pull/2108 (needed to cleanly apply the ZIP OOB patch)
      name = "update-appledouble-support-directories.patch";
      url = "https://github.com/libarchive/libarchive/commit/91f27004a5c88589658e38d68e46d223da6b75ca.patch";
      hash = "sha256-q8x5NPmMh2P4j4fMEdjAWG2srzJCyF37SEW42kRuAZM=";
    })
    (fetchpatch {
      # https://github.com/libarchive/libarchive/pull/2145
      name = "zip-out-of-bound-access.patch";
      url = "https://github.com/libarchive/libarchive/commit/b6a979481b7d77c12fa17bbed94576b63bbcb0c0.patch";
      hash = "sha256-9TRJzV1l13Fk2JKqoejDM/kl0BsaD8EuIa11+aGnShM=";
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

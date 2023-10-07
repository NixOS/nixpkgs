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
, buildPackages
}:

let
  autoreconfHook = buildPackages.autoreconfHook269;
in
assert xarSupport -> libxml2 != null;
stdenv.mkDerivation (finalAttrs: {
  pname = "libarchive";
  version = "3.6.2";

  src = fetchFromGitHub {
    owner = "libarchive";
    repo = "libarchive";
    rev = "v${finalAttrs.version}";
    hash = "sha256-wQbA6vlXH8pnpY7LJLkjrRFEBpcaPR1SqxnK71UVwxg=";
  };

  outputs = [ "out" "lib" "dev" ];

  patches = [
    # fixes static linking; upstream in releases after 3.6.2
    # https://github.com/libarchive/libarchive/pull/1825 merged upstream
    (assert finalAttrs.version == "3.6.2"; fetchpatch {
      name = "001-only-add-iconv-to-pc-file-if-needed.patch";
      url = "https://github.com/libarchive/libarchive/commit/1f35c466aaa9444335a1b854b0b7223b0d2346c2.patch";
      hash = "sha256-lb+zwWSH6/MLUIROvu9I/hUjSbb2jOWO755WC/r+lbY=";
    })
  ];

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

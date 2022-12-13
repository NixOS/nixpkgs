{ lib
, stdenv
, fetchFromGitHub
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

stdenv.mkDerivation rec {
  pname = "libarchive";
  version = "3.6.2";

  src = fetchFromGitHub {
    owner = "libarchive";
    repo = "libarchive";
    rev = "v${version}";
    hash = "sha256-wQbA6vlXH8pnpY7LJLkjrRFEBpcaPR1SqxnK71UVwxg=";
  };

  postPatch = ''
    substituteInPlace Makefile.am --replace '/bin/pwd' "$(type -P pwd)"

    declare -a skip_test_paths=(
      # test won't work in nix sandbox
      'libarchive/test/test_write_disk_perms.c'
      # can't be sure builder will have sparse-capable fs
      'libarchive/test/test_sparse_basic.c'
      # can't even be sure builder will have hardlink-capable fs
      'libarchive/test/test_write_disk_hardlink.c'
      # access-time-related tests flakey on some systems
      'cpio/test/test_option_a.c'
      'cpio/test/test_option_t.c'
    )

    for test_path in "''${skip_test_paths[@]}" ; do
      substituteInPlace Makefile.am --replace "$test_path" ""
      rm "$test_path"
    done
  '';

  outputs = [ "out" "lib" "dev" ];

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
    changelog = "https://github.com/libarchive/libarchive/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jcumming AndersonTorres ];
    platforms = platforms.all;
  };

  passthru.tests = {
    inherit cmake nix samba;
  };
}

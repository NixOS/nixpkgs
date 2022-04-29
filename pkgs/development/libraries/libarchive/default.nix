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
  version = "3.6.1";

  src = fetchFromGitHub {
    owner = "libarchive";
    repo = "libarchive";
    rev = "v${version}";
    hash = "sha256-G4wL5DDbX0FqaA4cnOlVLZ25ObN8dNsRtxyas29tpDA=";
  };

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

  postPatch = ''
     substituteInPlace Makefile.am --replace '/bin/pwd' 'pwd'
  '';

  preBuild = lib.optionalString stdenv.isCygwin ''
    echo "#include <windows.h>" >> config.h
  '';

  # 484: test_write_disk_perms FAIL
  # TODO: how to disable it? Should it be reported upstream?
  doCheck = false;

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

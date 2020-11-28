{
  fetchFromGitHub, stdenv, pkgconfig, autoreconfHook,
  acl, attr, bzip2, e2fsprogs, libxml2, lzo, openssl, sharutils, xz, zlib, zstd,

  # Optional but increases closure only negligibly. Also, while libxml2
  # builds fine on windows, but libarchive has trouble linking windows
  # things it depends on for some reason.
  xarSupport ? stdenv.hostPlatform.isUnix,
}:

assert xarSupport -> libxml2 != null;

stdenv.mkDerivation rec {
  pname = "libarchive";
  version = "3.4.3";

  src = fetchFromGitHub {
    owner = "libarchive";
    repo = "libarchive";
    rev = "v${version}";
    sha256 = "1y0v03p6zyv6plr2p0pid1qfgmk8hd427spj8xa93mcdmq5yc3s0";
  };

  outputs = [ "out" "lib" "dev" ];

  nativeBuildInputs = [ pkgconfig autoreconfHook ];
  buildInputs =
    stdenv.lib.optional stdenv.hostPlatform.isUnix sharutils
    ++ [ zlib bzip2 openssl xz lzo zstd ]
    ++ stdenv.lib.optionals stdenv.isLinux [ e2fsprogs attr acl ]
    ++ stdenv.lib.optional xarSupport libxml2;

  # Without this, pkgconfig-based dependencies are unhappy
  propagatedBuildInputs = stdenv.lib.optionals stdenv.isLinux [ attr acl ];

  configureFlags = stdenv.lib.optional (!xarSupport) "--without-xml2";

  preBuild = if stdenv.isCygwin then ''
    echo "#include <windows.h>" >> config.h
  '' else null;

  doCheck = false; # fails

  preFixup = ''
    sed -i $lib/lib/libarchive.la \
      -e 's|-lcrypto|-L${openssl.out}/lib -lcrypto|' \
      -e 's|-llzo2|-L${lzo}/lib -llzo2|'
  '';

  enableParallelBuilding = true;

  meta = {
    description = "Multi-format archive and compression library";
    longDescription = ''
      This library has code for detecting and reading many archive formats and
      compressions formats including (but not limited to) tar, shar, cpio, zip, and
      compressed with gzip, bzip2, lzma, xz, ...
    '';
    homepage = "http://libarchive.org";
    license = stdenv.lib.licenses.bsd3;
    platforms = with stdenv.lib.platforms; all;
    maintainers = with stdenv.lib.maintainers; [ jcumming ];
  };
}

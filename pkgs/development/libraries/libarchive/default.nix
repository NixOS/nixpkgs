{
  fetchFromGitHub, lib, stdenv, pkg-config, autoreconfHook,
  acl, attr, bzip2, e2fsprogs, libxml2, lzo, openssl, sharutils, xz, zlib, zstd,

  # Optional but increases closure only negligibly. Also, while libxml2
  # builds fine on windows, but libarchive has trouble linking windows
  # things it depends on for some reason.
  xarSupport ? stdenv.hostPlatform.isUnix,
}:

assert xarSupport -> libxml2 != null;

stdenv.mkDerivation rec {
  pname = "libarchive";
  version = "3.5.2";

  src = fetchFromGitHub {
    owner = "libarchive";
    repo = "libarchive";
    rev = "v${version}";
    sha256 = "sha256-H00UJ+ON1kBc19BgWBBKmO8f23oAg2mk7o9hhDhn50Q=";
  };

  outputs = [ "out" "lib" "dev" ];

  nativeBuildInputs = [ pkg-config autoreconfHook ];
  buildInputs =
    lib.optional stdenv.hostPlatform.isUnix sharutils
    ++ [ zlib bzip2 openssl xz lzo zstd ]
    ++ lib.optionals stdenv.isLinux [ e2fsprogs attr acl ]
    ++ lib.optional xarSupport libxml2;

  # Without this, pkg-config-based dependencies are unhappy
  propagatedBuildInputs = lib.optionals stdenv.isLinux [ attr acl ];

  configureFlags = lib.optional (!xarSupport) "--without-xml2";

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
    changelog = "https://github.com/libarchive/libarchive/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    platforms = with lib.platforms; all;
    maintainers = with lib.maintainers; [ jcumming ];
  };
}

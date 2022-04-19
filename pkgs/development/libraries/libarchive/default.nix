{
  fetchFromGitHub, lib, stdenv, pkg-config, autoreconfHook,
  acl, attr, bzip2, e2fsprogs, libxml2, lzo, openssl, sharutils, xz, zlib, zstd,
  fetchpatch,

  # Optional but increases closure only negligibly. Also, while libxml2
  # builds fine on windows, but libarchive has trouble linking windows
  # things it depends on for some reason.
  xarSupport ? stdenv.hostPlatform.isUnix,

  # for passthru.tests
  cmake, nix, samba
}:

assert xarSupport -> libxml2 != null;

stdenv.mkDerivation rec {
  pname = "libarchive";
  version = "3.5.3";

  src = fetchFromGitHub {
    owner = "libarchive";
    repo = "libarchive";
    rev = "v${version}";
    sha256 = "1q4ij55yirrbrk5iwnh3r90ayq92n02shxc4qkyf73h8zqlfrcj7";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2022-26280.patch";
      url = "https://github.com/libarchive/libarchive/commit/cfaa28168a07ea4a53276b63068f94fce37d6aff.patch";
      sha256 = "1xvgpj6l4a5i6sy5wvq7v9n7am43mcbgbfsvgzmpmrlkr148kn3g";
    })
    (fetchpatch {
      name = "oss-fuzz-38764-fix.patch";
      url = "https://github.com/libarchive/libarchive/commit/9ad5f077491b9536f01dadca1724385c39cd7613.patch";
      sha256 = "0106gc5vsp57yg2p7y2lyddradzgsbnmnbbj1g9pw6daypj3czhd";
    })
  ];

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

  passthru.tests = {
    inherit cmake nix samba;
  };

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

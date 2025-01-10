{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  perl,
  pkg-config,
  python3,
  xmlto,
  zip,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "zziplib";
  version = "0.13.78";

  src = fetchFromGitHub {
    owner = "gdraheim";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-8QxQrxqYO4LtB8prMqgz5a0QqvSKL7KzTkgi+VdHp6A=";
  };

  nativeBuildInputs = [
    cmake
    perl
    pkg-config
    python3
    xmlto
    zip
  ];
  buildInputs = [
    zlib
  ];

  # test/zziptests.py requires network access
  # (https://github.com/gdraheim/zziplib/issues/24)
  cmakeFlags = [
    "-DZZIP_TESTCVE=OFF"
    "-DBUILD_SHARED_LIBS=True"
    "-DBUILD_STATIC_LIBS=False"
    "-DBUILD_TESTS=OFF"
    "-DMSVC_STATIC_RUNTIME=OFF"
    "-DZZIPSDL=OFF"
    "-DZZIPTEST=OFF"
    "-DZZIPWRAP=OFF"
    "-DBUILDTESTS=OFF"
  ];

  meta = with lib; {
    homepage = "https://github.com/gdraheim/zziplib";
    changelog = "https://github.com/gdraheim/zziplib/blob/${version}/ChangeLog";
    description = "Library to extract data from files archived in a zip file";
    longDescription = ''
      The zziplib library is intentionally lightweight, it offers the ability to
      easily extract data from files archived in a single zip file.
      Applications can bundle files into a single zip archive and access them.
      The implementation is based only on the (free) subset of compression with
      the zlib algorithm which is actually used by the zip/unzip tools.
    '';
    license = with licenses; [
      lgpl2Plus
      mpl11
    ];
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.unix;
  };
}

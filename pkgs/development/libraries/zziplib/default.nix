{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, perl
, pkg-config
, python3
, xmlto
, zip
, zlib
}:

stdenv.mkDerivation rec {
  pname = "zziplib";
  version = "0.13.72";

  src = fetchFromGitHub {
    owner = "gdraheim";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Ht3fBgdrTm4mCi5uhgQPNtpGzADoRVOpSuGPsIS6y0Q=";
  };

  patches = [
    # apply https://github.com/gdraheim/zziplib/pull/113
    (fetchpatch {
      url = "https://github.com/gdraheim/zziplib/commit/82a7773cd17828a3b0a4f5f552ae80c1cc8777c7.diff";
      sha256 = "0ifqdzxwb5d19mziy9j6lhl8wj95jpxzm0d2c6y3bgwa931avd3y";
    })
    (fetchpatch {
      url = "https://github.com/gdraheim/zziplib/commit/1cd611514c5f9559eb9dfc191d678dfc991f66db.diff";
      sha256 = "11w9qa46xq49l113k266dnv8izzdk1fq4y54yy5w8zps8zd3xfny";
    })
    (fetchpatch {
      url = "https://github.com/gdraheim/zziplib/commit/e47b1e1da952a92f917db6fb19485b8a0b1a42f3.diff";
      sha256 = "0d032hkmi3s3db12z2zbppl2swa3gdpbj0c6w13ylv2g2ixglrwg";
    })
    # Fixes invalid pointer conversions that cause compilation to fail with clang 15+
    (fetchpatch {
      url = "https://github.com/gdraheim/zziplib/commit/38e4d5f561318fa825e6544c2ef55ac5899c81b0.diff";
      sha256 = "sha256-VJuFyiPhuAZlDxmNHBty+JbYwG85ea5u2sv7HZRHMwo=";
    })
  ];

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
    description = "Library to extract data from files archived in a zip file";
    longDescription = ''
      The zziplib library is intentionally lightweight, it offers the ability to
      easily extract data from files archived in a single zip file.
      Applications can bundle files into a single zip archive and access them.
      The implementation is based only on the (free) subset of compression with
      the zlib algorithm which is actually used by the zip/unzip tools.
    '';
    license = with licenses; [ lgpl2Plus mpl11 ];
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.unix;
  };
}

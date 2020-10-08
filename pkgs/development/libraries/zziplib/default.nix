{ stdenv
, perl
, pkg-config
, fetchFromGitHub
, fetchpatch
, zip
, unzip
, python3
, xmlto
, zlib
}:

stdenv.mkDerivation rec {
  pname = "zziplib";
  version = "0.13.71";

  src = fetchFromGitHub {
    owner = "gdraheim";
    repo = "zziplib";
    rev = "v${version}";
    sha256 = "P+7D57sc2oIABhk3k96aRILpGnsND5SLXHh2lqr9O4E=";
  };

  patches = [
    # Install man pages
    (fetchpatch {
      url = "https://github.com/gdraheim/zziplib/commit/5583ccc7a247ee27556ede344e93d3ac1dc72e9b.patch";
      sha256 = "wVExEZN8Ml1/3GicB0ZYsLVS3KJ8BSz8i4Gu46naz1Y=";
      excludes = [ "GNUmakefile" ];
    })

    # Fix man page formatting
    (fetchpatch {
      url = "https://github.com/gdraheim/zziplib/commit/22ed64f13dc239f86664c60496261f544bce1088.patch";
      sha256 = "ScFVWLc4LQPqkcHn9HK/VkLula4b5HzuYl0b5vi4Ikc=";
    })
  ];

  nativeBuildInputs = [
    perl
    pkg-config
    zip
    python3
    xmlto
  ];

  buildInputs = [
    zlib
  ];

  checkInputs = [
    unzip
  ];

  # tests are broken (https://github.com/gdraheim/zziplib/issues/20),
  # and test/zziptests.py requires network access
  # (https://github.com/gdraheim/zziplib/issues/24)
  doCheck = false;
  checkTarget = "check";

  meta = with stdenv.lib; {
    description = "Library to extract data from files archived in a zip file";

    longDescription = ''
      The zziplib library is intentionally lightweight, it offers the ability
      to easily extract data from files archived in a single zip
      file.  Applications can bundle files into a single zip archive and
      access them.  The implementation is based only on the (free) subset of
      compression with the zlib algorithm which is actually used by the
      zip/unzip tools.
    '';

    license = with licenses; [ lgpl2Plus mpl11 ];

    homepage = "http://zziplib.sourceforge.net/";

    maintainers = [ ];
    platforms = python3.meta.platforms;
  };
}

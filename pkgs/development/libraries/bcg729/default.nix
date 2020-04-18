{ stdenv
, fetchFromGitHub
, fetchpatch
, cmake
}:

stdenv.mkDerivation rec {
  pname = "bcg729";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "BelledonneCommunications";
    repo = pname;
    rev = version;
    sha256 = "05s0c5ps3a763y0v34wg5zghj0cdjnq4ch7g81848xxry7q90fwa";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/BelledonneCommunications/bcg729/commit/a5907daf1b111e4ad7aab4f558f57e2af1e37e55.patch";
      sha256 = "0445syfwj4w4chh8ak80rq77iqcr27924n1ld5snshk3d21nxd64";
    })
    (fetchpatch {
      url = "https://github.com/BelledonneCommunications/bcg729/commit/697bf6653a8c7421f0e821ee8d42471246e6850f.patch";
      sha256 = "1h3gf5sj2sg5cs5iv1lcav3lkqmd5jf4agvjzz83l89wd5f5hp5l";
    })
    (fetchpatch {
      url = "https://github.com/BelledonneCommunications/bcg729/commit/d63ce04a93711820d9a6985b1d11d8d91ed8e6b6.patch";
      sha256 = "1piwf63ci2gma6jd6b4adkvxirysvazf0vklb5pc6vx1g93nkgxs";
    })
  ];

  nativeBuildInputs = [ cmake ];

  meta = with stdenv.lib; {
    description = "Opensource implementation of both encoder and decoder of the ITU G729 Annex A/B speech codec";
    homepage = "https://linphone.org/technical-corner/bcg729";
    changelog = "https://gitlab.linphone.org/BC/public/bcg729/raw/${version}/NEWS";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ c0bw3b ];
    platforms = platforms.all;
  };
}

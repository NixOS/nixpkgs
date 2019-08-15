{stdenv, fetchurl
, drmSupport ? false # Digital Radio Mondiale
}:

with stdenv.lib;
stdenv.mkDerivation rec {
  pname = "faad2";
  version = "2.8.8";

  src = fetchurl {
    url = "mirror://sourceforge/faac/${pname}-${version}.tar.gz";
    sha256 = "1db37ydb6mxhshbayvirm5vz6j361bjim4nkpwjyhmy4ddfinmhl";
  };

  patches = let
    fp = { ver ? "2.8.8-3", pname, name ? (pname + ".patch"), sha256 }: fetchurl {
      url = "https://salsa.debian.org/multimedia-team/faad2/raw/debian/${ver}"
          + "/debian/patches/${pname}.patch?inline=false";
      inherit name sha256;
    };
  in [
    (fp {
      # critical bug addressed in vlc 3.0.7 (but we use system-provided faad)
      pname = "0004-Fix-a-couple-buffer-overflows";
      sha256 = "1mwycdfagz6wpda9j3cp7lf93crgacpa8rwr58p3x0i5cirnnmwq";
    })
    (fp {
      name = "CVE-2018-20362.patch";
      pname = "0009-syntax.c-check-for-syntax-element-inconsistencies";
      sha256 = "1z849l5qyvhyn5pvm6r07fa50nrn8nsqnrka2nnzgkhxlhvzpa81";
    })
    (fp {
      name = "CVE-2018-20194.patch";
      pname = "0010-sbr_hfadj-sanitize-frequency-band-borders";
      sha256 = "1b1kbz4mv0zhpq8h3djnvqafh1gn12nikk9v3jrxyryywacirah4";
    })
  ];

  configureFlags = []
    ++ optional drmSupport "--with-drm";

  meta = {
    description = "An open source MPEG-4 and MPEG-2 AAC decoder";
    homepage    = https://www.audiocoding.com/faad2.html;
    license     = licenses.gpl2;
    maintainers = with maintainers; [ codyopel ];
    platforms   = platforms.all;
  };
}

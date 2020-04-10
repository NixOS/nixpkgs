{ stdenv, fetchurl, autoreconfHook }:

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "libspf2";
  version = "1.2.10";

  src = fetchurl {
    url = "https://www.libspf2.org/spf/libspf2-${version}.tar.gz";
    sha256 = "1j91p0qiipzf89qxq4m1wqhdf01hpn1h5xj4djbs51z23bl3s7nr";
  };

  patches = [
    (fetchurl {
      name = "0001-gcc-variadic-macros.patch";
      url = "https://github.com/shevek/libspf2/commit/5852828582f556e73751076ad092f72acf7fc8b6.patch";
      sha256 = "1v6ashqzpr0xidxq0vpkjd8wd66cj8df01kyzj678ljzcrax35hk";
    })
  ];

  postPatch = ''
    # disable static bins compilation
    sed -i \
      -e '/bin_PROGRAMS/s/spfquery_static//' src/spfquery/Makefile.am \
      -e '/bin_PROGRAMS/s/spftest_static//' src/spftest/Makefile.am \
      -e '/bin_PROGRAMS/s/spfd_static//' src/spfd/Makefile.am \
      -e '/bin_PROGRAMS/s/spf_example_static//' src/spf_example/Makefile.am
  '';

  # autoreconf necessary because we modified automake files
  nativeBuildInputs = [ autoreconfHook ];

  doCheck = true;

  meta = {
    description = "Implementation of the Sender Policy Framework for SMTP authorization";
    homepage = "https://www.libspf2.org";
    license = with licenses; [ lgpl21Plus bsd2 ];
    maintainers = with maintainers; [ pacien ];
    platforms = platforms.all;
  };
}

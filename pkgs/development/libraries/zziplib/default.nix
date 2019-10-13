{ docbook_xml_dtd_412, fetchurl, stdenv, perl, python2, zip, xmlto, zlib, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "zziplib";
  version = "0.13.69";

  src = fetchurl {
    url = "https://github.com/gdraheim/zziplib/archive/v${version}.tar.gz";
    sha256 = "0i052a7shww0fzsxrdp3rd7g4mbzx7324a8ysbc0br7frpblcql4";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2018-17828.patch";
      url = "https://github.com/gdraheim/zziplib/commit/f609ae8971f3c0ce6.diff";
      sha256 = "0jhiz4fgr93wzh6q03avn95b2nsf6402jaki6hxirxyhs5v9ahry";
    })

    (fetchpatch {
      name = "CVE-2018-16548-part1.patch";
      url = "https://github.com/gdraheim/zziplib/commit/9411bde3e4a70a81ff3ffd256b71927b2d90dcbb.patch";
      sha256 = "0cy8i182zbvcqzs5z2j13d5sl7hbh59pkgw4xkyg5yz739q4fp9b";
    })
    (fetchpatch {
      name = "CVE-2018-16548-part2.patch";
      url = "https://github.com/gdraheim/zziplib/commit/d2e5d5c53212e54a97ad64b793a4389193fec687.patch";
      sha256 = "153wd4vab8xqj9avcpx8g2zw9qsp9nkaqi7yc65pz3r7xfcxwdla";
    })
    (fetchpatch {
      name = "CVE-2018-16548-part3.patch";
      url = "https://github.com/gdraheim/zziplib/commit/0e1dadb05c1473b9df2d7b8f298dab801778ef99.patch";
      sha256 = "0fs6dns8l7dz5a900397g8b7x62z72b0pbpdmwk1hnx6vb7z5rz5";
    })
  ];
  postPatch = ''
    sed -i -e s,--export-dynamic,, configure
  '';

  buildInputs = [ docbook_xml_dtd_412 perl python2 zip xmlto zlib ];

  # tests are broken (https://github.com/gdraheim/zziplib/issues/20),
  # and test/zziptests.py requires network access
  # (https://github.com/gdraheim/zziplib/issues/24)
  doCheck = false;

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

    homepage = http://zziplib.sourceforge.net/;

    maintainers = [ ];
    platforms = python2.meta.platforms;
  };
}

{ stdenv, fetchurl, fetchpatch }:

stdenv.mkDerivation {
  name = "openslp-2.0.0";

  src = fetchurl {
    url = "mirror://sourceforge/openslp/2.0.0/2.0.0/openslp-2.0.0.tar.gz";
    sha256 = "16splwmqp0400w56297fkipaq9vlbhv7hapap8z09gp5m2i3fhwj";
  };

  patches = [
    (fetchpatch {
      name = "openslp-2.0.0-null-pointer-deref.patch";
      url = "https://src.fedoraproject.org/cgit/rpms/openslp.git/plain/openslp-2.0.0-null-pointer-deref.patch";
      sha256 = "186f3rj3z2lf5h1lpbhqk0szj2a9far1p3mjqg6422f29yjfnz6a";
    })
    (fetchpatch {
      name = "openslp-2.0.0-CVE-2016-7567.patch";
      url = "https://src.fedoraproject.org/cgit/rpms/openslp.git/plain/openslp-2.0.0-cve-2016-7567.patch";
      sha256 = "0zp61axx93b7nrbsyhn2x4dnw7n9y6g4rys21hyqxk4khrnc2yr9";
    })
    ./CVE-2016-4912.patch
  ];

  meta = with stdenv.lib; {
    homepage = http://www.openslp.org/;
    description = "An open-source implementation of the IETF Service Location Protocol";
    maintainers = with maintainers; [ ttuegel ];
    license = licenses.bsd3;
    platforms = platforms.all;
  };

}

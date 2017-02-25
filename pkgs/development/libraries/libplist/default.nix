{ stdenv, fetchurl, pkgconfig, libxml2, swig2, python2Packages, glib }:

let
  inherit (python2Packages) python cython;
in stdenv.mkDerivation rec {
  name = "libplist-1.12";

  nativeBuildInputs = [ pkgconfig swig2 python cython  ];

  #patches = [ ./swig.patch ];

  propagatedBuildInputs = [ libxml2 glib ];

  passthru.swig = swig2;

  outputs = ["out" "dev" "bin" "py"];

  postFixup = ''
    moveToOutput "lib/${python.libPrefix}" "$py"
  '';

  src = fetchurl {
    url = "http://www.libimobiledevice.org/downloads/${name}.tar.bz2";
    sha256 = "1gj4nv0bvdm5y2sqm2vj2rn44k67ahw3mh6q614qq4nyngfdxzqf";
  };

  meta = {
    homepage = http://github.com/JonathanBeck/libplist;
    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.urkud ];
    knownVulnerabilities = [
      "CVE-2017-5209: base64decode function in base64.c allows attackers to obtain sensitive information from process memory or cause a denial of service"
      "CVE-2017-5545: attackers to obtain sensitive information from process memory or cause a denial of service"
      "CVE-2017-5834: A heap-buffer overflow in parse_dict_node"
      "CVE-2017-5835: A memory allocation error leading to DoS"
      "CVE-2017-5836: A type inconsistency in bplist.c"
    ];
  };
}

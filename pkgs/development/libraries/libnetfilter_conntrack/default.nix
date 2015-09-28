{ stdenv, fetchurl, pkgconfig, libnfnetlink, libmnl }:

let version = "1.0.5"; in
stdenv.mkDerivation rec {
  name = "libnetfilter_conntrack-${version}";

  src = fetchurl {
    url = "http://netfilter.org/projects/libnetfilter_conntrack/files/${name}.tar.bz2";
    sha256 = "0zcwjav1qgr7ikmvfmy7g3nc7s1kj4j4939d18mpyha9mwy4mv6r";
  };

  buildInputs = [ libmnl ];
  propagatedBuildInputs = [ libnfnetlink ];
  nativeBuildInputs = [ pkgconfig ];

  meta = with stdenv.lib; {
    inherit version;
    description = "Userspace library providing an API to the in-kernel connection tracking state table";
    longDescription = ''
      libnetfilter_conntrack is a userspace library providing a programming interface (API) to the
      in-kernel connection tracking state table. The library libnetfilter_conntrack has been
      previously known as libnfnetlink_conntrack and libctnetlink. This library is currently used
      by conntrack-tools among many other applications
    '';
    homepage = http://netfilter.org/projects/libnetfilter_conntrack/;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ nckx ];
  };
}

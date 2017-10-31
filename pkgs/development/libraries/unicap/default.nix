{ stdenv, fetchurl, libusb, libraw1394, dcraw, intltool, perl, v4l_utils }:

stdenv.mkDerivation rec {
  name = "libunicap-${version}";
  version="0.9.12";

  src = fetchurl {
    url = "http://www.unicap-imaging.org/downloads/${name}.tar.gz";
    sha256 = "05zcnnm4dfc6idihfi0fq5xka6x86zi89wip2ca19yz768sd33s9";
  };

  buildInputs = [ libusb libraw1394 dcraw intltool perl v4l_utils ];

  patches = [
    # Debian has a patch that fixes the build.
    (fetchurl {
      url = "https://sources.debian.net/data/main/u/unicap/0.9.12-2/debian/patches/1009_v4l1.patch";
      sha256 = "1lgypmhdj681m7d1nmzgvh19cz8agj2f31wlnfib0ha8i3g5hg5w";
    })
  ];

  postPatch = ''
    find . -type f -exec sed -e '/linux\/types\.h/d' -i '{}' ';'
    sed -e 's@/etc/udev@'"$out"'/&@' -i data/Makefile.*
  '';

  meta = with stdenv.lib; {
    description = "Universal video capture API";
    homepage = http://www.unicap-imaging.org/;
    maintainers = [ maintainers.raskin ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}

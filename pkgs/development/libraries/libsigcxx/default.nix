{ stdenv, fetchurl, pkgconfig, gnum4, gnome3 }:

stdenv.mkDerivation rec {
  pname = "libsigc++";
  version = "2.10.1";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "00v08km4wwzbh6vjxb21388wb9dm6g2xh14rgwabnv4c2wk5z8n9";
  };

  nativeBuildInputs = [ pkgconfig gnum4 ];

  doCheck = true;

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "libsigcxx";
    };
  };

  meta = with stdenv.lib; {
    homepage = https://libsigcplusplus.github.io/libsigcplusplus/;
    description = "A typesafe callback system for standard C++";
    license = licenses.lgpl21;
    platforms = platforms.all;
  };
}

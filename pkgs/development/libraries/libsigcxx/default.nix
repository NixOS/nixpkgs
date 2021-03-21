{ lib, stdenv, fetchurl, pkg-config, gnum4, gnome3 }:

stdenv.mkDerivation rec {
  pname = "libsigc++";
  version = "3.0.6";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1kn57b039lg20182lnchl1ys27vf34brn43f895cal8nc7sdq3mp";
  };

  nativeBuildInputs = [ pkg-config gnum4 ];

  doCheck = true;

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "libsigcxx";
    };
  };

  meta = with lib; {
    homepage = "https://libsigcplusplus.github.io/libsigcplusplus/";
    description = "A typesafe callback system for standard C++";
    license = licenses.lgpl21Plus;
    platforms = platforms.all;
  };
}

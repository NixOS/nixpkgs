{ stdenv, fetchurl, pkgconfig, icu, clucene_core, curl }:

stdenv.mkDerivation rec {

  pname = "sword";
  version = "1.7.4";

  src = fetchurl {
    url = "https://www.crosswire.org/ftpmirror/pub/sword/source/v1.7/${pname}-${version}.tar.gz";
    sha256 = "0g91kpfkwccvdikddffdbzd6glnp1gdvkx4vh04iyz10bb7shpcr";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ icu clucene_core curl ];

  prePatch = ''
    patchShebangs .;
  '';

  patches = [
    (fetchurl {
      url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/app-text/sword/files/sword-1.7.4-gcc6.patch";
      sha256 = "0cvnya5swc7dxabir6bz6la2h1qxd32g3xi06m9b5l5ahb6g10y7";
    })
  ];

  configureFlags = [ "--without-conf" "--enable-tests=no" ];
  CXXFLAGS = [
    "-Wno-unused-but-set-variable"
    # compat with icu61+ https://github.com/unicode-org/icu/blob/release-64-2/icu4c/readme.html#L554
    "-DU_USING_ICU_NAMESPACE=1"
  ];

  meta = with stdenv.lib; {
    description = "A software framework that allows research manipulation of Biblical texts";
    homepage = http://www.crosswire.org/sword/;
    platforms = platforms.linux;
    license = licenses.gpl2;
    maintainers = [ maintainers.piotr maintainers.AndersonTorres ];
  };

}

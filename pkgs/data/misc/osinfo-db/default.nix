{ stdenv, fetchurl, osinfo-db-tools, intltool, libxml2 }:

stdenv.mkDerivation rec {
  pname = "osinfo-db";
  version = "20190301";

  src = fetchurl {
    url = "https://releases.pagure.org/libosinfo/${pname}-${version}.tar.xz";
    sha256 = "1rjqizsglgdcjxi7kpbwm26krdkrlxacinjp9684sfzhqwdqi4as";
  };

  nativeBuildInputs = [ osinfo-db-tools intltool libxml2 ];

  phases = [ "installPhase" ];

  installPhase = ''
    osinfo-db-import --dir "$out/share/osinfo" "${src}"
  '';

  meta = with stdenv.lib; {
    description = "Osinfo database of information about operating systems for virtualization provisioning tools";
    homepage = https://libosinfo.org/;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}

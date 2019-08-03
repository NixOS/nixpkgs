{ stdenv, fetchurl, osinfo-db-tools, intltool, libxml2 }:

stdenv.mkDerivation rec {
  pname = "osinfo-db";
  version = "20190611";

  src = fetchurl {
    url = "https://releases.pagure.org/libosinfo/${pname}-${version}.tar.xz";
    sha256 = "00gkdkycicl4rlr8by61sfsgpjsiswr8b148fl2arinr4vz3n46h";
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

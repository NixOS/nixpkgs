{ stdenv, fetchurl, osinfo-db-tools, intltool, libxml2 }:

stdenv.mkDerivation rec {
  name = "osinfo-db-20180920";

  src = fetchurl {
    url = "https://releases.pagure.org/libosinfo/${name}.tar.xz";
    sha256 = "19jbzf1g523bkckli043q21hgbfv0043b5ib4zjiz8x98h7ngiac";
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

{ stdenv, fetchurl, osinfo-db-tools, intltool, libxml2 }:

stdenv.mkDerivation rec {
  name = "osinfo-db-20181214";

  src = fetchurl {
    url = "https://releases.pagure.org/libosinfo/${name}.tar.xz";
    sha256 = "18ym54wvhvjk66fqpsfvfd5b7d7743dvfqrcq91w1n71r20fkhcd";
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

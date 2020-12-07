{ stdenv, fetchurl, osinfo-db-tools, gettext, libxml2 }:

stdenv.mkDerivation rec {
  pname = "osinfo-db";
  version = "20201015";

  src = fetchurl {
    url = "https://releases.pagure.org/libosinfo/${pname}-${version}.tar.xz";
    sha256 = "1i20lribrb03vsn57q722mbmjhxqswq2y2dpii95ic5zxvnaj1qa";
  };

  nativeBuildInputs = [ osinfo-db-tools gettext libxml2 ];

  phases = [ "installPhase" ];

  installPhase = ''
    osinfo-db-import --dir "$out/share/osinfo" "${src}"
  '';

  meta = with stdenv.lib; {
    description = "Osinfo database of information about operating systems for virtualization provisioning tools";
    homepage = "https://gitlab.com/libosinfo/osinfo-db/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}

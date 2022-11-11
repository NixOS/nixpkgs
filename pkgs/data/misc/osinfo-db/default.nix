{ lib
, stdenv
, fetchurl
, osinfo-db-tools
, gettext
, libxml2
}:

stdenv.mkDerivation rec {
  pname = "osinfo-db";
  version = "20220830";

  src = fetchurl {
    url = "https://releases.pagure.org/libosinfo/${pname}-${version}.tar.xz";
    sha256 = "sha256-gRFkPZDeq4ONt/IT8VS+8uBXNQqcg0JF7gHdZEM7qvs=";
  };

  nativeBuildInputs = [
    osinfo-db-tools
    gettext
    libxml2
  ];

  installPhase = ''
    osinfo-db-import --dir "$out/share/osinfo" "${src}"
  '';

  meta = with lib; {
    description = "Osinfo database of information about operating systems for virtualization provisioning tools";
    homepage = "https://gitlab.com/libosinfo/osinfo-db/";
    changelog = "https://gitlab.com/libosinfo/osinfo-db/-/commits/v${version}";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.bjornfor ];
  };
}

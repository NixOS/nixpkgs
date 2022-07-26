{ lib
, stdenv
, fetchurl
, osinfo-db-tools
, gettext
, libxml2
}:

stdenv.mkDerivation rec {
  pname = "osinfo-db";
  version = "20220516";

  src = fetchurl {
    url = "https://releases.pagure.org/libosinfo/${pname}-${version}.tar.xz";
    sha256 = "sha256-1g9p2K/J3MU9dqL7aNVMJtH9w6giuVwYAd5Yw8Zs2m0=";
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
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}

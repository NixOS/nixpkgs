{ lib
, stdenv
, fetchurl
, osinfo-db-tools
, gettext
, libxml2
}:

stdenv.mkDerivation rec {
  pname = "osinfo-db";
  version = "20230308";

  src = fetchurl {
    url = "https://releases.pagure.org/libosinfo/${pname}-${version}.tar.xz";
    sha256 = "sha256-VGugTsxekzui1/PztDM6KYDUrk38UoSYm5xUdY8rkIg=";
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

{ lib, stdenv, fetchurl, gnome, libxslt }:

stdenv.mkDerivation rec {
  pname = "mobile-broadband-provider-info";
  version = "20220725";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-SEWuAcKH8t+wIrxi1ZoUiHP/xKZz9RAgViZXQm1jKs0=";
  };

  nativeBuildInputs = [
    # fixes configure: error: xsltproc not found
    libxslt
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
    };
  };

  meta = with lib; {
    description = "Mobile broadband service provider database";
    homepage = "https://wiki.gnome.org/Projects/NetworkManager/MobileBroadband/ServiceProviders";
    license = licenses.publicDomain;
    maintainers = [ ];
    platforms = platforms.all;
  };
}

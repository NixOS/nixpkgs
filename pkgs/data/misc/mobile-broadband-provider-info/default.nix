{ lib, stdenv, fetchurl, gnome, libxslt }:

stdenv.mkDerivation rec {
  pname = "mobile-broadband-provider-info";
  version = "20210805";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-a/ihVY6lVBr7xve0QV50zJ9aqYKbE07Ks+8ch0ElaLw=";
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

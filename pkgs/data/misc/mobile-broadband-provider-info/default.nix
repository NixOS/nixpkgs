{ lib, stdenv, fetchurl, gnome, libxslt }:

stdenv.mkDerivation rec {
  pname = "mobile-broadband-provider-info";
  version = "20220315";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-H82sctF52xQnl4Nm9wG+HDx1Nf1aZYvFzIKCR8b2RcY=";
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

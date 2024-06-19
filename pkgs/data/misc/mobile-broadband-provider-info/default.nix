{ lib, stdenv, fetchurl, gnome, libxslt }:

stdenv.mkDerivation rec {
  pname = "mobile-broadband-provider-info";
  version = "20230416";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-4+FAqi23abKZ0d+GqJDpSKuZ1NOIMTAsRS0ft/hWiuw=";
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
    homepage = "https://gitlab.gnome.org/GNOME/mobile-broadband-provider-info";
    license = licenses.publicDomain;
    maintainers = [ ];
    platforms = platforms.all;
  };
}

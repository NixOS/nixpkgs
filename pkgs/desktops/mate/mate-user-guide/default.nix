{ lib
, stdenv
, fetchurl
, gettext
, itstool
, libxml2
, yelp
, mateUpdateScript
}:

stdenv.mkDerivation rec {
  pname = "mate-user-guide";
  version = "1.26.1";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "XQTJdLd/L/OQQkQ4mY6F7ErdjiJnJA51WnqODvd/wi8=";
  };

  nativeBuildInputs = [
    itstool
    gettext
    libxml2
  ];

  buildInputs = [
    yelp
  ];

  postPatch = ''
    substituteInPlace mate-user-guide.desktop.in.in \
      --replace "Exec=yelp" "Exec=${yelp}/bin/yelp"
  '';

  enableParallelBuilding = true;

  passthru.updateScript = mateUpdateScript { inherit pname; };

  meta = with lib; {
    description = "MATE User Guide";
    homepage = "https://mate-desktop.org";
    license = with licenses; [ gpl2Plus fdl11Plus ];
    platforms = platforms.unix;
    maintainers = teams.mate.members;
  };
}

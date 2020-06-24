{ lib, mkFont, fetchzip }:

mkFont rec {
  pname = "ir-standard-fonts";
  version = "20170121";

  src = fetchzip {
    url = "https://github.com/molaeiali/ir-standard-fonts/archive/${version}.zip";
    sha256 = "0p8dlk859dqm3qif4h6kn4v8nbs5i7zkhy38x3hgx7gp2m47qmx3";
  };

  meta = with lib; {
    homepage = "https://github.com/morealaz/ir-standard-fonts";
    description = "Iran Supreme Council of Information and Communication Technology (SCICT) standard Persian fonts series";
    # License information is unavailable.
    license = licenses.unfree;
    platforms = platforms.all;
    maintainers = [ maintainers.linarcx ];
  };
}

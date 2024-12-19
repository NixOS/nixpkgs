{
  stdenv,
  lib,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "virt-what";
  version = "1.27";

  src = fetchurl {
    url = "https://people.redhat.com/~rjones/virt-what/files/${pname}-${version}.tar.gz";
    sha256 = "sha256-1Nm9nUrlkJVZdEP6xmNJUxXH60MwuHKqXwYt84rGm/E=";
  };

  meta = with lib; {
    description = "Detect if running in a virtual machine and prints its type";
    homepage = "https://people.redhat.com/~rjones/virt-what/";
    maintainers = with maintainers; [ fpletz ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    mainProgram = "virt-what";
  };
}

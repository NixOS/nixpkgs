{
  stdenv,
  lib,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "virt-what";
  version = "1.27";

  src = fetchurl {
    url = "https://people.redhat.com/~rjones/virt-what/files/virt-what-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-1Nm9nUrlkJVZdEP6xmNJUxXH60MwuHKqXwYt84rGm/E=";
  };

  meta = {
    description = "Detect if running in a virtual machine and prints its type";
    homepage = "https://people.redhat.com/~rjones/virt-what/";
    maintainers = with lib.maintainers; [ fpletz ];
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "virt-what";
  };
})

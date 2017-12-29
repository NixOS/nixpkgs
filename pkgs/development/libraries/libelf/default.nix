{ stdenv, fetchurl
, gettext, glibc
, buildPlatform, hostPlatform
}:

stdenv.mkDerivation rec {
  name = "libelf-0.8.13";

  src = fetchurl {
    url = "http://www.mr511.de/software/${name}.tar.gz";
    sha256 = "0vf7s9dwk2xkmhb79aigqm0x0yfbw1j0b9ksm51207qwr179n6jr";
  };

  patches = [
    ./dont-hardcode-ar.patch
  ];

  doCheck = true;

  # FIXME needs gcc 4.9 in bootstrap tools
  hardeningDisable = [ "stackprotector" ];

  # Libelf's custom NLS macros fail to determine the catalog file extension on
  # Darwin, so disable NLS for now.
  # FIXME: Eventually make Gettext a build input on all platforms.
  configureFlags = stdenv.lib.optional hostPlatform.isDarwin "--disable-nls";

  nativeBuildInputs = [ gettext ];

  meta = {
    description = "ELF object file access library";

    homepage = http://www.mr511.de/software/english.html;

    license = stdenv.lib.licenses.lgpl2Plus;

    platforms = stdenv.lib.platforms.all;
    maintainers = [ ];
  };
}

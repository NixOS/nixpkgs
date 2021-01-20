{ stdenv, fetchurl, pkg-config, glib }:

stdenv.mkDerivation rec {
  name = "libvisual-0.4.0";

  src = fetchurl {
    url = "mirror://sourceforge/libvisual/${name}.tar.gz";
    sha256 = "1my1ipd5k1ixag96kwgf07bgxkjlicy9w22jfxb2kq95f6wgsk8b";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ glib ];

  hardeningDisable = [ "format" ];

  configureFlags = stdenv.lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    "ac_cv_func_malloc_0_nonnull=yes"
    "ac_cv_func_realloc_0_nonnull=yes"
  ];

  meta = {
    description = "An abstraction library for audio visualisations";
    homepage = "https://sourceforge.net/projects/libvisual/";
    license = stdenv.lib.licenses.lgpl21Plus;
    platforms = stdenv.lib.platforms.linux;
  };
}

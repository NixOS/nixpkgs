{stdenv, fetchgit, autoconf, automake, libtool, libaacs ? null, jdk ? null, ant ? null, withAACS ? false}:

assert withAACS -> jdk != null && ant != null && libaacs != null;

# Info on how to use:
# https://wiki.archlinux.org/index.php/BluRay

let baseName = "libbluray";
    version  = "0.2.1";

in

stdenv.mkDerivation {
  name = "${baseName}-${version}";

  src = fetchgit {
    url = git://git.videolan.org/libbluray.git;
    rev = "3b9a9f044644a6abe9cb09377f714ded9fdd6c87";
    sha256 = "551b623e76c2dba44b5490fb42ccdc491b28cd42841de28237b8edbed0f0711c";
  };

  nativeBuildInputs = [autoconf automake libtool];
  buildInputs = stdenv.lib.optionals withAACS [jdk ant libaacs];
  NIX_LDFLAGS = stdenv.lib.optionalString withAACS "-laacs";

  preConfigure = "./bootstrap";
  configureFlags = ["--disable-static"] ++ stdenv.lib.optionals withAACS ["--enable-bdjava" "--with-jdk=${jdk}"];

  meta = {
    homepage = http://www.videolan.org/developers/libbluray.html;
    description = "Library to access Blu-Ray disks for video playback";
    license = stdenv.lib.licenses.lgpl21;
  };
}

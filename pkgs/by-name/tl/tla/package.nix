{ stdenv, fetchurl, which, diffutils, gnupatch, gnutar }:

stdenv.mkDerivation rec {
  pname = "tla";
  version = "1.3.5";

  src = fetchurl {
    url = "https://ftp.gnu.org/old-gnu/gnu-arch/tla-${version}.tar.gz";
    sha256 = "01mfzj1i6p4s8191cgd5850hds1zls88hkf9rb6qx1vqjv585aj0";
  };

  patches = [ ./configure-tmpdir.patch ];

  buildInputs = [ which ];

  propagatedBuildInputs = [ diffutils gnupatch gnutar ];

  # Instead of GNU Autoconf, tla uses Tom Lord's now
  # defunct `package-framework'.
  buildPhase = ''
    mkdir +build && cd +build &&		\
    ../src/configure --prefix="$out" &&		\
    make install
  '';

  meta = {
    description = "GNU Arch (aka. `tla'), a distributed revision control system";
    mainProgram = "tla";
    homepage = "https://www.gnu.org/software/gnu-arch/";
    license = "GPL";
  };
}

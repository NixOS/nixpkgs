{ stdenv, fetchurl, autoreconfHook, libGLU_combined }:

let version = "1.0"; in

stdenv.mkDerivation rec {
  name = "libtxc_dxtn_s2tc-${version}";

  src = fetchurl {
    url = "https://github.com/divVerent/s2tc/archive/v${version}.tar.gz";
    sha256 = "0ibfdib277fhbqvxzan0bmglwnsl1y1rw2g8skvz82l1sfmmn752";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ libGLU_combined ];

  meta = {
    description = "A patent-free S3TC compatible implementation";
    homepage = https://github.com/divVerent/s2tc;
    repositories.git = https://github.com/divVerent/s2tc.git;
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.cpages ];
  };
}

{ stdenv, fetchFromGitHub, pkg-config, glib, zlib, libpng, cmake }:

let
  version = "0.3.95";
  pname = "lensfun";
in
stdenv.mkDerivation {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "lensfun";
    repo = "lensfun";
    rev = "v${version}";
    sha256 = "0isli0arns8bmxqpbr1jnbnqh5wvspixdi51adm671f9ngng7x5r";
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ glib zlib libpng ];

  cmakeFlags = [ "-DINSTALL_HELPER_SCRIPTS=OFF" ];

  meta = with stdenv.lib; {
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ flokli ];
    license = stdenv.lib.licenses.lgpl3;
    description = "An opensource database of photographic lenses and their characteristics";
    homepage = "https://lensfun.github.io";
  };
}

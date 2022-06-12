{ lib, stdenv, fetchFromGitHub, pkg-config, glib, zlib, libpng, cmake }:

let
  version = "0.3.95";
  pname = "lensfun";

  # Fetch a more recent version of the repo containing a more recent lens
  # database
  lensfunDatabase = fetchFromGitHub {
    owner = "lensfun";
    repo = "lensfun";
    rev = "4672d765a17bfef7bc994ca7008cb717c61045d5";
    sha256 = "00x35xhpn55j7f8qzakb6wl1ccbljg1gqjb93jl9w3mha2bzsr41";
  };

in
stdenv.mkDerivation {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "lensfun";
    repo = "lensfun";
    rev = "v${version}";
    sha256 = "0isli0arns8bmxqpbr1jnbnqh5wvspixdi51adm671f9ngng7x5r";
  };

  # replace database with a more recent snapshot
  prePatch = ''
    rm -R ./data/db
    cp -R ${lensfunDatabase}/data/db ./data
  '';

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ glib zlib libpng ];

  cmakeFlags = [ "-DINSTALL_HELPER_SCRIPTS=OFF" ];

  meta = with lib; {
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ flokli ];
    license = lib.licenses.lgpl3;
    description = "An opensource database of photographic lenses and their characteristics";
    homepage = "https://lensfun.github.io";
  };
}

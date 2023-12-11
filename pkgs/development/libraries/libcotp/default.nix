{ stdenv, lib, fetchFromGitHub, cmake, pkg-config, libgcrypt }:

stdenv.mkDerivation rec {
  pname = "libcotp";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "paolostivanin";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-5zyQSoz5d/HYrIaj0ChtZYK79bBNlYDsFMSDuzcVhY0=";
  };

  postPatch = lib.optionalString stdenv.cc.isClang ''
    substituteInPlace CMakeLists.txt \
      --replace "add_link_options(-Wl," "# add_link_options(-Wl,"
  '';

  buildInputs = [ libgcrypt ];
  nativeBuildInputs = [ cmake pkg-config ];

  meta = with lib; {
    description = "C library that generates TOTP and HOTP";
    homepage = "https://github.com/paolostivanin/libcotp";
    license = licenses.asl20;
    maintainers = with maintainers; [ alexbakker ];
    platforms = platforms.all;
  };
}

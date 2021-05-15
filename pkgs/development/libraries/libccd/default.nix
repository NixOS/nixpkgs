{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "libccd";
  version = "2.1";

  src = fetchFromGitHub {
    owner = "danfis";
    repo = pname;
    rev = "v${version}";
    sha256 = "0sfmn5pd7k5kyhbxnd689xmsa5v843r7sska96dlysqpljd691jc";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "Library for collision detection between two convex shapes";
    homepage = "https://github.com/danfis/libccd";
    license = licenses.bsd3;
    maintainers = with maintainers; [ lopsided98 ];
    platforms = platforms.unix;
  };
}

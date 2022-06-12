{ lib
, stdenv
, fetchurl
, fetchpatch
, perl
}:

stdenv.mkDerivation rec {
  pname = "gecode";
  version = "3.7.3";

  src = fetchurl {
    url = "http://www.gecode.org/download/${pname}-${version}.tar.gz";
    sha256 = "0k45jas6p3cyldgyir1314ja3174sayn2h2ly3z9b4dl3368pk77";
  };

  patches = [
    (import ./fix-const-weights-clang-patch.nix fetchpatch)
  ];

  nativeBuildInputs = [ perl ];

  preConfigure = "patchShebangs configure";

  meta = with lib; {
    broken = stdenv.isDarwin;
    license = licenses.mit;
    homepage = "https://www.gecode.org";
    description = "Toolkit for developing constraint-based systems";
    platforms = platforms.all;
    maintainers = [ maintainers.manveru ];
  };
}

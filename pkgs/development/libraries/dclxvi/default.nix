{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  name = "dclxvi-2013-01-27";

  src = fetchFromGitHub {
    owner = "agl";
    repo = "dclxvi";
    rev = "74009d58f2305be3b95d88717619bde8ecbdd9a2";
    sha256 = "1kx4h8iv7yb30c6zjmj8zs9x12vxhi0jwkiwxsxj9swf6bww6p1g";
  };

  buildFlags = [ "libdclxvipairing.so" ];

  installPhase = ''
    mkdir -p $out/{include,lib}
    find . -name \*.h -exec cp {} $out/include \;
    find . -name \*.so -exec cp {} $out/lib \;
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/agl/dclxvi";
    description = "Naehrig, Niederhagen and Schwabe's pairings code, massaged into a shared library";
    maintainers = with maintainers; [ wkennington ];
    platforms = platforms.all;
  };
}

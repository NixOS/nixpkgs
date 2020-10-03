{ stdenv, lib, fetchFromGitHub, python3, zopfli, pngquant, imagemagick, which }:

let
  python = python3.withPackages (
    ps: with ps; [
      fonttools
      nototools
    ]
  );

in
stdenv.mkDerivation rec {
  pname = "apple-color-emoji";
  version = "unstable-2020-04-13";

  src = fetchFromGitHub {
    owner = "samuelngs";
    repo = "apple-emoji-linux";
    rev = "8c247a77eb0abe9fca1011a6ab75520dc761ff37";
    sha256 = "1r0laf5g4gjrrv2xzr1l5bvkn7px9k02p6wknxaafm3mrmpxrk23";
  };

  dontConfigure = true;

  nativeBuildInputs = [ python zopfli pngquant imagemagick which ];

  enableParallelBuilding = true;

  patchPhase = ''
    substituteInPlace Makefile --replace 'HOME/.local/' 'out/'
  '';

  meta = with stdenv.lib; {
    description = "Color typeface used by iOS and macOS to display emoji";
    homepage = "https://github.com/samuelngs/apple-emoji-linux";
    license = with licenses; [ ofl asl20 ];
    maintainers = with maintainers; [ btwiusegentoo ];
  };
}

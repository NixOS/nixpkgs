{ stdenv, fetchFromGitHub, cmake, SDL2}:

#TODO: tests

stdenv.mkDerivation rec {
	pname = "faudio";
  version = "20.05";

  src = fetchFromGitHub {
    owner = "FNA-XNA";
    repo = "FAudio";
    rev = version;
    sha256 = "14i0s0m1n57wjwzy54v1czq0w38xplcdsfn4nz5v6fryaxzr5z60";
  };

	nativeBuildInputs = [cmake];

  buildInputs = [ SDL2 ];

  meta = with stdenv.lib; {
    description = "XAudio reimplementation focusing to develop a fully accurate DirectX audio library";
    homepage = "https://github.com/FNA-XNA/FAudio";
    license = licenses.zlib;
    platforms = platforms.linux;
    maintainers = [ maintainers.marius851000 ];
  };
}

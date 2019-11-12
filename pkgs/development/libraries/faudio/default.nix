{ stdenv, fetchFromGitHub, cmake, SDL2}:

#TODO: tests

stdenv.mkDerivation rec {
	pname = "faudio";
  version = "19.11";

  src = fetchFromGitHub {
    owner = "FNA-XNA";
    repo = "FAudio";
    rev = version;
    sha256 = "0ckpr6ffz8ssfh1y850dhip5s5jv0j6n90qz5yx1v9d6gpwf08rp";
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

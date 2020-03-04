{ stdenv, fetchFromGitHub, cmake, SDL2}:

#TODO: tests

stdenv.mkDerivation rec {
	pname = "faudio";
  version = "20.02";

  src = fetchFromGitHub {
    owner = "FNA-XNA";
    repo = "FAudio";
    rev = version;
    sha256 = "07f3n8qxjbrn7dhyi90l1zx5klsr3qiw14n0jdk589jgynhjgv5r";
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

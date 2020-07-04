{ stdenv, fetchFromGitHub, cmake, SDL2}:

#TODO: tests

stdenv.mkDerivation rec {
	pname = "faudio";
  version = "20.06";

  src = fetchFromGitHub {
    owner = "FNA-XNA";
    repo = "FAudio";
    rev = version;
    sha256 = "1dyx9l7ldhlbb77ca3wk0l218589blvh78mdfyzpk9k1izk2yih1";
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

{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "QuadProgpp";
  version = "4b6bd65f09fbff99c172a86d6e96ca74449b323f";

  src = fetchFromGitHub {
    owner = "liuq";
    repo = "QuadProgpp";
    rev = version;
    sha256 = "02r0dlk2yjpafknvm945vbgs4sl26w2i1gw3pllar9hi364y8hnx";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ ];

  meta = with stdenv.lib; {
    homepage = https://github.com/liuq/QuadProgpp;
    license = licenses.mit;
    description = ''
      A C++ library for Quadratic Programming which implements the
      Goldfarb-Idnani active-set dual method.
    '';
    maintainers = with maintainers; [ ];
    platforms = with platforms; linux;
  };
}

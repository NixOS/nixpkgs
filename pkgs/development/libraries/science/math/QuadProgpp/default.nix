{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "QuadProgpp";
  version = "1.2.2pre";
  versionSuffix = "_" + builtins.substring 0 7 src.rev;

  src = fetchFromGitHub {
    owner = "liuq";
    repo = "QuadProgpp";
    rev = "4b6bd65f09fbff99c172a86d6e96ca74449b323f";
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

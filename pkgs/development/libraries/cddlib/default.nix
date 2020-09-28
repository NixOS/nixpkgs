{ stdenv
, fetchFromGitHub
, gmp
, autoreconfHook
, texlive
}:

stdenv.mkDerivation rec {
  pname = "cddlib";
  version = "0.94l";
  src = fetchFromGitHub {
    owner = "cddlib";
    repo = "cddlib";
    rev = version;
    sha256 = "0934a0i2m2bamlibi4cbrf1md1pz7dp35jbfamb0k7x644sayl4k";
  };
  buildInputs = [gmp];
  nativeBuildInputs = [
    autoreconfHook
    texlive.combined.scheme-small # for building the documentation
  ];
  # No actual checks yet (2018-05-05), but maybe one day.
  # Requested here: https://github.com/cddlib/cddlib/issues/25
  doCheck = true;
  meta = with stdenv.lib; {
    inherit version;
    description = ''An implementation of the Double Description Method for generating all vertices of a convex polyhedron'';
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [raskin timokau];
    platforms = platforms.unix;
    homepage = "https://www.inf.ethz.ch/personal/fukudak/cdd_home/index.html";
  };
}

{ autoconf
, automake
, fetchFromGitHub
, lib
, libtool
, perl
, pkg-config
, python3
, stdenv
}:

stdenv.mkDerivation {
  pname = "openpgm";
  version = "5.3.128";

  src = fetchFromGitHub {
    owner = "steve-o";
    repo = "openpgm";
    rev = "release-5-3-128";
    sha256 = "sha256-jBIKUjMjcrFMNLpvbJo0Ym0IuvN6JQpmGfRalTrf3E4=";
  };

  nativeBuildInputs = [ autoconf automake libtool perl pkg-config python3 ];

  preConfigure = ''
    cd openpgm/pgm

    # The 5.3.128 release doesn't contain an openpgm-5.3.pc.in file. It still
    # incorrectly contains an openpgm-5.2.pc.in file.  Just renaming the file
    # works.
    #
    # This can probably be removed when updating to the next version.
    cp openpgm-5.2.pc.in openpgm-5.3.pc.in

    ./bootstrap.sh
  '';

  meta = with lib; {
    homepage = "https://www.freshports.org/net/openpgm/";
    description = "Implementation of the Pragmatic General Multicast (PGM, RFC3208)";
    license = licenses.lgpl21Plus;
    platforms = platforms.all;
    maintainers = teams.bitnomial.members;
  };
}

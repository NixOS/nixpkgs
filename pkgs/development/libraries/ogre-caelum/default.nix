{ stdenv, lib, fetchFromGitHub, cmake, pkg-config, ogre }:

stdenv.mkDerivation rec {
  pname = "ogre-caelum";
  version = "unstable-2021-05-10";

  src = fetchFromGitHub {
    owner = "OGRECave";
    repo = pname;
    rev = "94913d2040a41148c14001c33a0bdc0f100842f8";
    sha256 = "rNkBTbGztqW/9ROTLgJ1gsyQ0S+JNSRIL1ZWHLhw+MU=";
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ ogre ];

  meta = with lib; {
    description = "Plugin for OGRE for rendering of dynamic and realistic skies";
    homepage = "https://wiki.ogre3d.org/Caelum";
    maintainers = with maintainers; [ luc65r ];
    license = licenses.mit;
    platforms = platforms.linux;
  };
}

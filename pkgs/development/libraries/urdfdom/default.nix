{ lib, stdenv, fetchFromGitHub, fetchpatch, cmake, pkg-config, validatePkgConfig
, tinyxml, boost, urdfdom-headers, console-bridge }:

stdenv.mkDerivation rec {
  pname = "urdfdom";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "ros";
    repo = pname;
    rev = version;
    sha256 = "0wambq06d7dvja25zcv4agc055q9rmf3xkrnxy8lsf4nic7ra2rr";
  };

  patches = [
    # Fix CMake saying console-bridge 1.0 is incompatible
    (fetchpatch {
      url = "https://github.com/ros/urdfdom/commit/6faba176d41cf39114785a3e029013f941ed5a0e.patch";
      sha256 = "1pn9hcg5wkkc7y28sbkxvffqxgvazzsp3g1xmz6h055v4f9ikjbs";
    })
    # Fix CMake relative install dir assumptions (https://github.com/ros/urdfdom/pull/142)
    (fetchpatch {
      url = "https://github.com/ros/urdfdom/commit/707c97c3d1f739ba0ab6e93e1bf7cd01d68a8c07.patch";
      sha256 = "10bv7sv7gfy6lj8z5bkw7v291y12fbrrxsiqxqjxg4i65rfg92ng";
    })
  ];

  nativeBuildInputs = [ cmake pkg-config validatePkgConfig ];
  buildInputs = [ tinyxml boost ];
  propagatedBuildInputs = [ urdfdom-headers console-bridge ];

  meta = with lib; {
    description = "Provides core data structures and a simple XML parser for populating the class data structures from an URDF file";
    homepage = "https://github.com/ros/urdfdom";
    license = licenses.bsd3;
    maintainers = with maintainers; [ lopsided98 ];
    platforms = platforms.all;
  };
}

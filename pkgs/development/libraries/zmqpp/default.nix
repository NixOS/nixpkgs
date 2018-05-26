{ stdenv, fetchFromGitHub, cmake, pkgconfig, zeromq }:

stdenv.mkDerivation rec {
  name = "zmqpp-${version}";
  version = "4.2.0";

  src = fetchFromGitHub {
    owner = "zeromq";
    repo = "zmqpp";
    rev = version;
    sha256 = "08v34q3sd8g1b95k73n7jwryb0xzwca8ib9dz8ngczqf26j8k72i";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ cmake pkgconfig ];

  propagatedBuildInputs = [ zeromq ];

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "C++ wrapper for czmq. Aims to be minimal, simple and consistent";
    license = licenses.lgpl3;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ chris-martin ];
  };
}

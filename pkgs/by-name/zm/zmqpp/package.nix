{ lib, stdenv, fetchFromGitHub, cmake, pkg-config, zeromq }:

stdenv.mkDerivation rec {
  pname = "zmqpp";
  version = "4.2.0";

  src = fetchFromGitHub {
    owner = "zeromq";
    repo = "zmqpp";
    rev = version;
    sha256 = "08v34q3sd8g1b95k73n7jwryb0xzwca8ib9dz8ngczqf26j8k72i";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ cmake pkg-config ];

  propagatedBuildInputs = [ zeromq ];

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "C++ wrapper for czmq. Aims to be minimal, simple and consistent";
    license = licenses.lgpl3;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ chris-martin ];
  };
}

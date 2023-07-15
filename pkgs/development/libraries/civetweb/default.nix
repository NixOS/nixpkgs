{ lib
, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "civetweb";
  version = "1.15";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Qh6BGPk7a01YzCeX42+Og9M+fjXRs7kzNUCyT4mYab4=";
  };

  outputs = [ "out" "dev" ];

  strictDeps = true;

  nativeBuildInputs = [
    cmake
  ];

  # The existence of the "build" script causes `mkdir -p build` to fail:
  #   mkdir: cannot create directory 'build': File exists
  preConfigure = ''
    rm build
  '';

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    "-DCIVETWEB_ENABLE_CXX=ON"
    "-DCIVETWEB_ENABLE_IPV6=ON"

    # The civetweb unit tests rely on downloading their fork of libcheck.
    "-DCIVETWEB_BUILD_TESTING=OFF"
  ];

  meta = {
    description = "Embedded C/C++ web server";
    homepage = "https://github.com/civetweb/civetweb";
    license = [ lib.licenses.mit ];
  };
}

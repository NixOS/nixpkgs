{ lib, stdenv
, fetchFromGitHub
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

  makeFlags = [
    "WITH_CPP=1"
    "PREFIX=${placeholder "out"}"
    "LIBDIR=${placeholder "out"}/lib"
    "INCLUDEDIR=${placeholder "dev"}/include"
  ];

  patches = [
    ./0001-allow-setting-paths-in-makefile.patch
  ];

  strictDeps = true;

  outputs = [ "out" "dev" ];

  installTargets = [
    "install-headers"
    "install-lib"
    "install-slib"
    "install"
  ];

  preInstall = ''
    mkdir -p $dev/include
    mkdir -p $out/lib
  '';

  meta = {
    description = "Embedded C/C++ web server";
    homepage = "https://github.com/civetweb/civetweb";
    license = [ lib.licenses.mit ];
  };
}

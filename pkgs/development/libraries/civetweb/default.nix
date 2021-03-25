{ lib, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "civetweb";
  version = "1.13";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "/q7Q1lavIR3i126uI4NsKByHJ6Tp+DSN60R4YxR506U=";
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

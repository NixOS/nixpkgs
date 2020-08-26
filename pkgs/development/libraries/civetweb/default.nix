{ stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "civetweb";
  version = "1.11";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "1drnid6gs97cp9zpvsxz42yfj8djmgx98fg9p2993x9mpi547vzv";
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

  preInstall = ''
    mkdir -p $dev/include
    mkdir -p $out/lib
  '';

  meta = {
    description = "Embedded C/C++ web server";
    homepage = "https://github.com/civetweb/civetweb";
    license = [ stdenv.lib.licenses.mit ];
  };
}

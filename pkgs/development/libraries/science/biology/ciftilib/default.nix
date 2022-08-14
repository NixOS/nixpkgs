{ lib
, stdenv
, fetchFromGitHub
, cmake
, boost
, libxmlxx
, pkg-config
, zlib
}:

stdenv.mkDerivation rec {
  pname = "ciftilib";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "Washington-University";
    repo = "CiftiLib";
    rev = "v${version}";
    hash = "sha256-xc2dpMse4SozYEV/w3rXCrh1LKpTThq5nHB2y5uAD0A=";
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ boost libxmlxx zlib ];

  cmakeFlags = [ "-DCMAKE_CTEST_ARGUMENTS=--exclude-regex;'big|datatype-md5'" ];

  doCheck = true;

  meta = with lib; {
    homepage = "https://github.com/Washington-University/CiftiLib";
    description = "Library for reading and writing CIFTI files";
    maintainers = with maintainers; [ bcdarwin ];
    platforms = platforms.linux;
    license = licenses.bsd2;
  };
}

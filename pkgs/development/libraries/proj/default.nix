{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, pkg-config
, sqlite
, libtiff
, curl
, gtest
}:

stdenv.mkDerivation rec {
  pname = "proj";
  version = "8.1.1";

  src = fetchFromGitHub {
    owner = "OSGeo";
    repo = "PROJ";
    rev = version;
    sha256 = "sha256-Z2nruyowC3NG4Wb8AFBL0PME/zp9D7SwQdMSl6VjH/w=";
  };

  patches = [
    (fetchpatch {
      name = "Make-CApi-test-cross-platform.patch";
      url = "https://github.com/OSGeo/PROJ/commit/ac113a8898cded7f5359f1edd3abc17a78eee9b4.patch";
      sha256 = "0gz2xa5nxzck5c0yr7cspv3kw4cz3fxb2yic76w7qfvxidi7z1s1";
    })
  ];

  outputs = [ "out" "dev"];

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ sqlite libtiff curl ];

  checkInputs = [ gtest ];

  cmakeFlags = [
    "-DUSE_EXTERNAL_GTEST=ON"
    "-DRUN_NETWORK_DEPENDENT_TESTS=OFF"
  ];

  doCheck = true;

  meta = with lib; {
    description = "Cartographic Projections Library";
    homepage = "https://proj.org/";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ vbgl dotlambda ];
  };
}

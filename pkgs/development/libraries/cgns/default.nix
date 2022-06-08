{ stdenv
, lib
, fetchFromGitHub
, cmake
, hdf5
}:

stdenv.mkDerivation rec {
  pname = "CGNS";
  version = "4.3.0";

  outputs = [ "bin" "out" "dev" ];

  src = fetchFromGitHub {
    owner = "CGNS";
    repo = "CGNS";
    rev = "v${version}";
    sha256 = "bVvauoZPOZiU9eudaZXtsEp1nTua4ydiDhOnTY8PL0o=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    hdf5
  ];

  cmakeFlags = [
    "-DCMAKE_SKIP_BUILD_RPATH=OFF"
    "-DCGNS_BUILD_TESTING=ON"
    "-DCGNS_ENABLE_TESTS=ON"
  ];

  doCheck = true;

  postInstall = ''
    moveToOutput bin "''${!outputBin}"
  '';

  meta = with lib; {
    description = "Standard for recording and recovering computer data associated with the numerical solution of fluid dynamics equations";
    homepage = "https://cgns.github.io/";
    license = licenses.zlib;
    platforms = platforms.unix;
    maintainers = with maintainers; [ jtojnar ];
  };
}

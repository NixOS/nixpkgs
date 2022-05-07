{ stdenv
, lib
, fetchFromGitHub
, cmake
, perl
, pkg-config
, libffi
, pugixml
, nlohmann_json
, libyamlcpp
, atl
, dill
# , ffs
# , enet
# , evpath
}:

stdenv.mkDerivation rec {
  pname = "ADIOS2";
  version = "2.8.0";

  src = fetchFromGitHub {
    owner = "ornladios";
    repo = "ADIOS2";
    rev = "v${version}";
    sha256 = "IiOmufc9WgCLlGEOyPber79Q/GHkJrRGlhg3eVdZ2FU=";
  };

  nativeBuildInputs = [
    cmake
    perl
    pkg-config
  ];

  buildInputs = [
    libffi
    pugixml
    nlohmann_json
    libyamlcpp
    atl
    dill
    # ffs
    # enet
    # evpath
  ];

  cmakeFlags = [
    "-DADIOS2_USE_EXTERNAL_DEPENDENCIES=ON"
    "-DADIOS2_USE_EXTERNAL_ATL=ON"
    "-DADIOS2_USE_EXTERNAL_DILL=ON"
    # The following break build:
    # "-DADIOS2_USE_EXTERNAL_FFS=ON"
    # "-DADIOS2_USE_EXTERNAL_EVPATH=ON"
    # "-DADIOS2_USE_EXTERNAL_ENET=ON"

    # Does not handle absolute paths in libdir
    "-DCMAKE_INSTALL_LIBDIR=lib"

    # Slow
    "-DADIOS2_BUILD_EXAMPLES=OFF"
  ];

  postPatch = ''
    patchShebangs cmake/install/post/generate-adios2-config.sh.in
  '';

  meta = with lib; {
    description = "Adaptable Input/Output System";
    homepage = "https://adios2.readthedocs.io/";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ jtojnar ];
  };
}

{ stdenv, fetchzip, fetchFromGitHub, boost, cmake, z3 }:

let
  version = "0.4.23";
  rev = "124ca40dc525a987a88176c6e5170978e82fa290";
  sha256 = "07l8rfqh95yrdmbxc4pfb77s06k5v65dk3rgdqscqmwchkndrmm0";
  jsoncppURL = https://github.com/open-source-parsers/jsoncpp/archive/1.7.7.tar.gz;
  jsoncpp = fetchzip {
    url = jsoncppURL;
    sha256 = "0jz93zv17ir7lbxb3dv8ph2n916rajs8i96immwx9vb45pqid3n0";
  };
in

stdenv.mkDerivation {
  name = "solc-${version}";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "solidity";
    inherit rev sha256;
  };

  patches = [
    ./patches/boost-shared-libs.patch
    ./patches/shared-libs-install.patch
  ];

  postPatch = ''
    touch prerelease.txt
    echo >commit_hash.txt "${rev}"
    substituteInPlace cmake/jsoncpp.cmake \
      --replace "${jsoncppURL}" ${jsoncpp}
    substituteInPlace cmake/EthCompilerSettings.cmake \
      --replace "add_compile_options(-Werror)" ""
  '';

  cmakeFlags = [
    "-DBoost_USE_STATIC_LIBS=OFF"
    "-DBUILD_SHARED_LIBS=ON"
    "-DINSTALL_LLLC=ON"
    "-DTESTS=OFF"
  ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [ boost z3 ];

  outputs = [ "out" "dev" ];

  meta = with stdenv.lib; {
    description = "Compiler for Ethereum smart contract language Solidity";
    longDescription = "This package also includes `lllc', the LLL compiler.";
    homepage = https://github.com/ethereum/solidity;
    license = licenses.gpl3;
    platforms = with platforms; linux ++ darwin;
    maintainers = with maintainers; [ dbrock akru ];
    inherit version;
  };
}

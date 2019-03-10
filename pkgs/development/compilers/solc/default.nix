{ stdenv, fetchzip, fetchFromGitHub, boost, cmake
, z3Support ? true, z3 ? null
}:

assert z3Support -> z3 != null;
assert z3Support -> stdenv.lib.versionAtLeast z3.version "4.6.0";

let
  version = "0.5.4";
  rev = "9549d8fff7343908228c3e8bedc309d1b83fc204";
  sha256 = "1r6wklp3ab2s1lrm70zv6p7blv9917ph1arjsb250j7b7bpjg5pq";
  jsoncppURL = https://github.com/open-source-parsers/jsoncpp/archive/1.8.4.tar.gz;
  jsoncpp = fetchzip {
    url = jsoncppURL;
    sha256 = "1z0gj7a6jypkijmpknis04qybs1hkd04d1arr3gy89lnxmp6qzlm";
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
    ./patches/shared-libs-install.patch
  ];

  postPatch = ''
    touch prerelease.txt
    echo >commit_hash.txt "${rev}"
    substituteInPlace cmake/jsoncpp.cmake \
      --replace "${jsoncppURL}" ${jsoncpp}
  '';

  cmakeFlags = [
    "-DBoost_USE_STATIC_LIBS=OFF"
    "-DBUILD_SHARED_LIBS=ON"
  ] ++ stdenv.lib.optionals (!z3Support) [
    "-DUSE_Z3=OFF"
  ];

  doCheck = stdenv.hostPlatform.isLinux && stdenv.hostPlatform == stdenv.buildPlatform;
  checkPhase = "LD_LIBRARY_PATH=./libsolc:./libsolidity:./libevmasm:./libdevcore:./libyul:./liblangutil:$LD_LIBRARY_PATH " +
               "./test/soltest -p -- --no-ipc --no-smt --testpath ../test";

  nativeBuildInputs = [ cmake ];
  buildInputs = [ boost ]
    ++ stdenv.lib.optionals z3Support [ z3 ];

  outputs = [ "out" "dev" ];

  meta = with stdenv.lib; {
    description = "Compiler for Ethereum smart contract language Solidity";
    homepage = https://github.com/ethereum/solidity;
    license = licenses.gpl3;
    platforms = with platforms; linux ++ darwin;
    maintainers = with maintainers; [ dbrock akru lionello ];
    inherit version;
  };
}

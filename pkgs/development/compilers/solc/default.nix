{ stdenv, fetchzip, fetchFromGitHub, boost, cmake, ncurses, python2
, z3Support ? true, z3 ? null
}:

assert z3Support -> z3 != null;
assert z3Support -> stdenv.lib.versionAtLeast z3.version "4.6.0";

let
  version = "0.5.8";
  rev = "23d335f28e4055e67c3b22466ac7c4e41dc48344";
  sha256 = "10fa4qwfr3gfvxkzzjfs0w2fyij67cczklpj2x5hghcg08amkq37";
  jsoncppURL = https://github.com/open-source-parsers/jsoncpp/archive/1.8.4.tar.gz;
  jsoncpp = fetchzip {
    url = jsoncppURL;
    sha256 = "1z0gj7a6jypkijmpknis04qybs1hkd04d1arr3gy89lnxmp6qzlm";
  };
  buildSharedLibs = stdenv.hostPlatform.isLinux;
in
stdenv.mkDerivation {
  name = "solc-${version}";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "solidity";
    inherit rev sha256;
  };

  patches = stdenv.lib.optionals buildSharedLibs [ ./patches/shared-libs-install.patch ];

  postPatch = ''
    touch prerelease.txt
    echo >commit_hash.txt "${rev}"
    substituteInPlace cmake/jsoncpp.cmake \
      --replace "${jsoncppURL}" ${jsoncpp}
  '';

  cmakeFlags = [
    "-DBoost_USE_STATIC_LIBS=OFF"
  ] ++ stdenv.lib.optionals buildSharedLibs [
    "-DBUILD_SHARED_LIBS=ON"
  ] ++ stdenv.lib.optionals (!z3Support) [
    "-DUSE_Z3=OFF"
  ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [ boost ] ++ stdenv.lib.optionals z3Support [ z3 ];
  checkInputs = [ ncurses python2 ];

  # Test fails on darwin for unclear reason
  doCheck = stdenv.hostPlatform.isLinux;

  checkPhase = ''
    while IFS= read -r -d ''' dir
    do
      LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$(pwd)/$dir
      export LD_LIBRARY_PATH
    done <   <(find . -type d -print0)

    pushd ..
    # IPC tests need aleth avaliable, so we disable it
    sed -i "s/IPC_ENABLED=true/IPC_ENABLED=false\nIPC_FLAGS=\"--no-ipc\"/" ./scripts/tests.sh
    for i in ./scripts/*.sh; do
      patchShebangs "$i"
    done
    for i in ./scripts/*.py; do
      patchShebangs "$i"
    done
    for i in ./test/*.sh; do
      patchShebangs "$i"
    done
    TERM=xterm ./scripts/tests.sh
    popd
  '';

  outputs = [ "out" "dev" ];

  meta = with stdenv.lib; {
    description = "Compiler for Ethereum smart contract language Solidity";
    homepage = https://github.com/ethereum/solidity;
    license = licenses.gpl3;
    platforms = with platforms; linux ++ darwin;
    maintainers = with maintainers; [ dbrock akru lionello sifmelcara ];
    inherit version;
  };
}

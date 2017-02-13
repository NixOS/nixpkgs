{ stdenv, fetchFromGitHub, cmake, makeWrapper
, llvmPackages_39, hiredis, z3_opt, gtest
}:

let
  klee = fetchFromGitHub {
    owner = "klee";
    repo  = "klee";
    rev   = "a743d7072d9ccf11f96e3df45f25ad07da6ad9d6";
    sha256 = "0qwzs029vlba8xz362n4b00hdm2z3lzhzmvix1r8kpbfrvs8vv91";
  };
in stdenv.mkDerivation {
  name = "souper-unstable-2017-01-05";

  src = fetchFromGitHub {
    owner  = "google";
    repo   = "souper";
    rev    = "1be75fe6a96993b57dcba038798fe6d1c7d113eb";
    sha256 = "0r8mjb88lwz9a3syx7gwsxlwfg0krffaml04ggaf3ad0cza2mvm8";
  };

  nativeBuildInputs = [
    cmake
    makeWrapper
  ];

  buildInputs = [
    llvmPackages_39.llvm
    llvmPackages_39.clang-unwrapped
    hiredis
    gtest
  ];

  enableParallelBuilding = true;

  preConfigure = ''
      mkdir -pv third_party
      cp -R "${klee}" third_party/klee
  '';

  installPhase = ''
      mkdir -pv $out/bin
      cp -v ./souper       $out/bin/
      cp -v ./clang-souper $out/bin/
      wrapProgram "$out/bin/souper" \
          --add-flags "-z3-path=\"${z3_opt}/bin/z3\""
  '';

  meta = with stdenv.lib; {
    description = "A superoptimizer for LLVM IR";
    homepage    = "https://github.com/google/souper";
    license     = licenses.asl20;
    maintainers = with maintainers; [ taktoa ];
    platforms   = with platforms; linux;
  };
}

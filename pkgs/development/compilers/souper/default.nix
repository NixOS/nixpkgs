{ stdenv, fetchFromGitHub, cmake, makeWrapper
, llvmPackages_4, hiredis, z3_opt, gtest
}:

let
  klee = fetchFromGitHub {
    owner = "rsas";
    repo  = "klee";
    rev   = "57cd3d43056b029d9da3c6b3c666c4153554c04f";
    sha256 = "197wb7nbirlfpx2jr3afpjjhcj7slc4dxxi02j3kmazz9kcqaygz";
  };
in stdenv.mkDerivation rec {
  name = "souper-unstable-${version}";
  version = "2017-03-23";

  src = fetchFromGitHub {
    owner  = "google";
    repo   = "souper";
    rev    = "cf2911d2eb1e7c8ab465df5a722fa5cdac06e6fc";
    sha256 = "1kg08a1af4di729pn1pip2lzqzlvjign6av95214f5rr3cq2q0cl";
  };

  nativeBuildInputs = [
    cmake
    makeWrapper
  ];

  buildInputs = [
    llvmPackages_4.llvm
    llvmPackages_4.clang-unwrapped
    hiredis
    gtest
  ];

  patches = [ ./cmake-fix.patch ];

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

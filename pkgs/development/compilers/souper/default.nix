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
in stdenv.mkDerivation {
  name = "souper-unstable-2017-03-07";

  src = fetchFromGitHub {
    owner  = "google";
    repo   = "souper";
    rev    = "5faed54ddc4a0e0e12647a0eac1da455a1067a47";
    sha256 = "1v8ml94ryw5wdls9syvicx4sc9l34yaq8r7cf7is6x7y1q677rps";
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

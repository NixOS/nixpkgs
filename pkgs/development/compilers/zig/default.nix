{ lib
, stdenv
, fetchFromGitHub
, cmake
, llvmPackages
, libxml2
, zlib
}:

llvmPackages.stdenv.mkDerivation rec {
  pname = "zig";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "ziglang";
    repo = pname;
    rev = version;
    hash = "sha256-rZYv8LFH3M70SyPwPVyul+Um9j82K8GZIepVmaonzPw=";
  };

  nativeBuildInputs = [
    cmake llvmPackages.llvm.dev
  ];
  buildInputs = [
    libxml2
    zlib
  ] ++ (with llvmPackages; [
    libclang
    lld
    llvm
  ]);

  preBuild = ''
    export HOME=$TMPDIR;
  '';

  checkPhase = ''
    runHook preCheck
    ./zig test --cache-dir "$TMPDIR" -I $src/test $src/test/stage1/behavior.zig
    runHook postCheck
  '';

  doCheck = true;

  meta = with lib; {
    homepage = "https://ziglang.org/";
    description =
      "General-purpose programming language and toolchain for maintaining robust, optimal, and reusable software";
    license = licenses.mit;
    maintainers = with maintainers; [ andrewrk AndersonTorres ];
    platforms = platforms.unix;
    # See https://github.com/NixOS/nixpkgs/issues/86299
    broken = stdenv.isDarwin;
  };
}

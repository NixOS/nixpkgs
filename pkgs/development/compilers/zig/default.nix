{ stdenv, fetchFromGitHub, cmake, llvmPackages, libxml2, zlib, substituteAll }:

llvmPackages.stdenv.mkDerivation rec {
  version = "0.7.1";
  pname = "zig";

  src = fetchFromGitHub {
    owner = "ziglang";
    repo = pname;
    rev = version;
    sha256 = "1z6c4ym9jmga46cw2arn7zv2drcpmrf3vw139gscxp27n7q2z5md";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    llvmPackages.clang-unwrapped
    llvmPackages.llvm
    llvmPackages.lld
    libxml2
    zlib
  ];

  preBuild = ''
    export HOME=$TMPDIR;
  '';

  checkPhase = ''
    runHook preCheck
    ./zig test --cache-dir "$TMPDIR" -I $src/test $src/test/stage1/behavior.zig
    runHook postCheck
  '';

  doCheck = true;

  meta = with stdenv.lib; {
    description =
      "General-purpose programming language and toolchain for maintaining robust, optimal, and reusable software";
    homepage = "https://ziglang.org/";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = [ maintainers.andrewrk ];
    # See https://github.com/NixOS/nixpkgs/issues/86299
    broken = stdenv.isDarwin;
  };
}

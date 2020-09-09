{ stdenv, fetchFromGitHub, cmake, llvmPackages, libxml2, zlib, substituteAll }:

llvmPackages.stdenv.mkDerivation rec {
  version = "0.6.0";
  pname = "zig";

  src = fetchFromGitHub {
    owner = "ziglang";
    repo = pname;
    rev = version;
    sha256 = "13dwm2zpscn4n0p5x8ggs9n7mwmq9cgip383i3qqphg7m3pkls8z";
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
    ./zig test $src/test/stage1/behavior.zig
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
  };
}

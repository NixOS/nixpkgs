{ stdenv, fetchFromGitHub, cmake, llvmPackages, libxml2, zlib }:

stdenv.mkDerivation rec {
  version = "0.5.0";
  pname = "zig";

  src = fetchFromGitHub {
    owner = "ziglang";
    repo = pname;
    rev = version;
    sha256 = "0xyl0riakh6kwb3yvxihb451kqs4ai4q0aygqygnlb2rlr1dn1zb";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ llvmPackages.clang-unwrapped llvmPackages.llvm libxml2 zlib ];

  preBuild = ''
    export HOME=$TMPDIR;
  '';

  meta = with stdenv.lib; {
    description = "Programming languaged designed for robustness, optimality, and clarity";
    homepage = https://ziglang.org/;
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = [ maintainers.andrewrk ];
  };
}

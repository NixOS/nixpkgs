{ lib
, pkgs
, stdenv
, fetchFromGitHub
, python3
, boost
, capstone
, z3
, llvm
, cmake }:

stdenv.mkDerivation rec {
  pname = "libtriton";
  version = "0.9";

  src = fetchFromGitHub {
    owner = "JonathanSalwan";
    repo = "Triton";
    rev = "v${version}";
    sha256 = "sha256-97I38cW9VEAUmWOMMk6xRFA+u2uDf2TIgHz25CxB9h8=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ python3 boost capstone z3 llvm ];
  enableParallelBuilding = true;

  cmakeFlags = [
    "-DLLVM_INTERFACE=ON"
  ];

  installPhase = ''
    mkdir $out/
    cp src/libtriton/libtriton.so $out

    mkdir -p $py/${python3.sitePackages}
    cp src/libtriton/triton.so $py/${python3.sitePackages}
  '';

  outputs = [ "out" "py" ];

  meta = with lib; {
    description = "Triton is a dynamic binary analysis library. Build your own program analysis tools, automate your reverse engineering, perform software verification or just emulate code.";
    homepage = "https://triton-library.github.io/";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ oposs ];
  };
}

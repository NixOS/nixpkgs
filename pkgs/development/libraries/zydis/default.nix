{ lib
, stdenv
, fetchFromGitHub
, callPackage
, cmake
, python3
}:

let
  zycore = callPackage ./zycore.nix {
    inherit stdenv fetchFromGitHub cmake;
  };
in
stdenv.mkDerivation rec {
  pname = "zydis";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "zyantific";
    repo = "zydis";
    rev = "v${version}";
    hash = "sha256-/no/8FNa5LlwhZMSMao4/cwZk6GlamLjqr+isbh6tEI=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ zycore ];
  cmakeFlags = [
    "-DZYAN_SYSTEM_ZYCORE=ON"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
  ];

  doCheck = true;
  checkInputs = [ python3 ];
  checkPhase = ''
    pushd ../tests
    python3 ./regression.py test ../build/ZydisInfo
    python3 ./regression_encoder.py \
      ../build/Zydis{Fuzz{ReEncoding,Encoder},TestEncoderAbsolute}
    popd
  '';

  passthru = { inherit zycore; };

  meta = with lib; {
    homepage = "https://zydis.re/";
    description = "Fast and lightweight x86/x86-64 disassembler library";
    license = licenses.mit;
    maintainers = with maintainers; [ jbcrail AndersonTorres athre0z ];
    platforms = platforms.all;
  };
}

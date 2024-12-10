{
  lib,
  stdenv,
  fetchFromGitHub,
  python3Packages,
  llvmPackages,
}:

let
  # mbuild is a custom build system used only to build xed
  mbuild = python3Packages.buildPythonPackage rec {
    pname = "mbuild";
    version = "2022.07.28";

    src = fetchFromGitHub {
      owner = "intelxed";
      repo = "mbuild";
      rev = "v${version}";
      sha256 = "sha256-nVHHiaPbf+b+RntjUGjLLGS53e6c+seXIBx7AcTtiWU=";
    };
  };

in
stdenv.mkDerivation rec {
  pname = "xed";
  version = "2024.02.22";

  src = fetchFromGitHub {
    owner = "intelxed";
    repo = "xed";
    rev = "v${version}";
    sha256 = "sha256-LF4iJ1/Z3OifCiir/kU3ufZqtiRLeaJeAwuBqP2BCF4=";
  };

  nativeBuildInputs = [ mbuild ] ++ lib.optionals stdenv.isDarwin [ llvmPackages.bintools ];

  buildPhase = ''
    patchShebangs mfile.py

    # this will build, test and install
    ./mfile.py test --prefix $out
    ./mfile.py examples
    mkdir -p $out/bin
    cp ./obj/wkit/examples/obj/xed $out/bin/
  '';

  dontInstall = true; # already installed during buildPhase

  meta = with lib; {
    broken = stdenv.isAarch64;
    description = "Intel X86 Encoder Decoder (Intel XED)";
    homepage = "https://intelxed.github.io/";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ arturcygan ];
  };
}

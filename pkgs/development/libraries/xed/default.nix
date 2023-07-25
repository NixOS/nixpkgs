{ lib, stdenv, fetchFromGitHub, python3Packages }:

let
  # mbuild is a custom build system used only to build xed
  mbuild = python3Packages.buildPythonPackage rec {
    pname = "mbuild";
    version = "2022.07.28";

    src = fetchFromGitHub {
      owner = "intelxed";
      repo = "mbuild";
      rev = "v${version}";
      sha256 = "sha256-eOAqmoPotdXGcBmrD9prXph4XOL6noJU6GYT/ud/VXk=";
    };
  };

in stdenv.mkDerivation rec {
  pname = "xed";
  version = "2022.08.11";

  src = fetchFromGitHub {
    owner = "intelxed";
    repo = "xed";
    rev = "v${version}";
    sha256 = "sha256-Iil+dfjuWYPbzmSjgwKTKScSE/IsWuHEKQ5HsBJDqWM=";
  };

  nativeBuildInputs = [ mbuild ];

  buildPhase = ''
    patchShebangs mfile.py

    # this will build, test and install
    ./mfile.py test --prefix $out
  '';

  dontInstall = true; # already installed during buildPhase

  meta = with lib; {
    broken = (stdenv.isLinux && stdenv.isAarch64);
    description = "Intel X86 Encoder Decoder (Intel XED)";
    homepage    = "https://intelxed.github.io/";
    license     = licenses.asl20;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ arturcygan ];
  };
}

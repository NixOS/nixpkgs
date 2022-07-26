{ lib, stdenv, fetchFromGitHub, python3Packages }:

let
  # mbuild is a custom build system used only to build xed
  mbuild = python3Packages.buildPythonPackage rec {
    pname = "mbuild";
    version = "0.2496-dev";

    src = fetchFromGitHub {
      owner = "intelxed";
      repo = "mbuild";
      rev = "3e8eb33aada4153c21c4261b35e5f51f6e2019e8";
      sha256 = "0yamgzkzw4v6x1a857psw9f7i62ydgd0zaqrf33dbdg8hfd2mq3q";
    };
  };

in stdenv.mkDerivation rec {
  pname = "xed";
  version = "12.0.1";

  src = fetchFromGitHub {
    owner = "intelxed";
    repo = "xed";
    rev = version;
    sha256 = "07zfff8zf29c2n0wal87hiqfq3cwcjn80zz78mz0nyjfj09nd39f";
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

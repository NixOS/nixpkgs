{ lib, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "argtable";
  version = "3.1.5";
  srcVersion = "v${version}.1c1bb23";

  src = fetchFromGitHub {
    owner = "argtable";
    repo = "argtable3";
    rev = srcVersion;
    sha256 = "sha256-sL6mnxsuL1K0DY26jLF/2Czo0RxHYJ3xU3VyavISiMM=";
  };

  nativeBuildInputs = [ cmake ];

  postPatch = ''
    patchShebangs tools/build
  '';

  meta = with lib; {
    homepage = "https://argtable.org";
    description = "A single-file, ANSI C command-line parsing library";
    longDescription = ''
      Argtable is an open source ANSI C library that parses GNU-style
      command-line options. It simplifies command-line parsing by defining a
      declarative-style API that you can use to specify what your command-line
      syntax looks like. Argtable will automatically generate consistent error
      handling logic and textual descriptions of the command line syntax, which
      are essential but tedious to implement for a robust CLI program.
    '';
    license = with licenses; bsd3;
    maintainers = with maintainers; [ AndersonTorres artuuge ];
    platforms = with platforms; all;
  };
}
# TODO [ AndersonTorres ]: a NixOS test suite

{ lib
, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "argtable";
  version = "3.2.1";
  srcVersion = "v${version}.52f24e5";

  src = fetchFromGitHub {
    owner = "argtable";
    repo = "argtable3";
    rev = srcVersion;
    hash = "sha256-HFsk91uJXQ0wpvAQxP4/yZwRQx9kLH7KgB3Y/+zcZC0=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
  ];

  postPatch = ''
    patchShebangs tools/build
  '';

  meta = with lib; {
    homepage = "https://github.com/argtable/argtable3";
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
# TODO: a NixOS test suite
# TODO: multiple outputs
# TODO: documentation
# TODO: build both shared and static libs

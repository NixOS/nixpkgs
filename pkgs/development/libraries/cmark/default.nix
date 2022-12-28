{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "cmark";
  version = "0.30.2";

  src = fetchFromGitHub {
    owner = "jgm";
    repo = pname;
    rev = version;
    sha256 = "sha256-IkNybUe/XYwAvPowym3aqfVyvNdw2t/brRjhOrjVRpA=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags =
    # Link the executable with the shared library on system with shared libraries.
    lib.optional (!stdenv.hostPlatform.isStatic) "-DCMARK_STATIC=OFF"
    # Do not attempt to build .so library on static platform.
    ++ lib.optional stdenv.hostPlatform.isStatic "-DCMARK_SHARED=OFF";

  doCheck = true;

  preCheck = let
    lib_path = if stdenv.isDarwin then "DYLD_FALLBACK_LIBRARY_PATH" else "LD_LIBRARY_PATH";
  in ''
    export ${lib_path}=$(readlink -f ./src)
  '';

  meta = with lib; {
    description = "CommonMark parsing and rendering library and program in C";
    homepage = "https://github.com/jgm/cmark";
    maintainers = [ maintainers.michelk ];
    platforms = platforms.unix;
    license = licenses.bsd2;
  };
}

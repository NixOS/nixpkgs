{ lib
, stdenv
, cmake
, fetchFromGitHub
, fixDarwinDylibNames
}:

stdenv.mkDerivation rec {
  pname = "capstone";
  version = "5.0.1";

  src = fetchFromGitHub {
    owner = "capstone-engine";
    repo = "capstone";
    rev = version;
    sha256 = "sha256-kKmL5sae9ruWGu1gas1mel9qM52qQOD+zLj8cRE3isg=";
  };

  cmakeFlags = [ "-DBUILD_SHARED_LIBS=ON" ];

  nativeBuildInputs = [
    cmake
  ] ++ lib.optionals stdenv.isDarwin [
    fixDarwinDylibNames
  ];

  doCheck = true;

  meta = {
    description = "Advanced disassembly library";
    homepage    = "http://www.capstone-engine.org";
    license     = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ thoughtpolice ris ];
    mainProgram = "cstool";
    platforms   = lib.platforms.unix;
  };
}

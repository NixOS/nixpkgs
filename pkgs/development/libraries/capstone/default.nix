{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
  fixDarwinDylibNames,
}:

stdenv.mkDerivation rec {
  pname = "capstone";
  version = "5.0.6";

  src = fetchFromGitHub {
    owner = "capstone-engine";
    repo = "capstone";
    rev = version;
    hash = "sha256-ovIvsxVq+/q5UUMzP4WpxzaE0898uayNc1g2Coignnc=";
  };

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" true)
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ (lib.cmakeBool "CAPSTONE_BUILD_MACOS_THIN" true) ];

  nativeBuildInputs = [
    cmake
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    fixDarwinDylibNames
  ];

  doCheck = true;

  meta = {
    description = "Advanced disassembly library";
    homepage = "http://www.capstone-engine.org";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      thoughtpolice
      ris
    ];
    mainProgram = "cstool";
    platforms = lib.platforms.unix;
  };
}

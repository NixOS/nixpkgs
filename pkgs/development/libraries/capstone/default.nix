{ lib
, stdenv
, cmake
, fetchFromGitHub
, fixDarwinDylibNames
, static ? stdenv.hostPlatform.isStatic
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "capstone";
  version = "5.0.1";

  src = fetchFromGitHub {
    owner = "aquynh";
    repo = "capstone";
    rev = finalAttrs.finalPackage.version;
    sha256 = "sha256-kKmL5sae9ruWGu1gas1mel9qM52qQOD+zLj8cRE3isg=";
  };

  # can remove once upstream get their own version right
  postPatch = ''
    sed -E -i 's/^(\s+VERSION )[0-9.]+/\1${finalAttrs.version}/' CMakeLists.txt
  '';

  nativeBuildInputs = [
    cmake
  ] ++ lib.optionals stdenv.isDarwin [
    fixDarwinDylibNames
  ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=${if static then "OFF" else "ON"}"
    "-DCAPSTONE_BUILD_CSTOOL=ON"
    "-DCAPSTONE_BUILD_TESTS=${if finalAttrs.finalPackage.doCheck then "ON" else "OFF"}"
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
})

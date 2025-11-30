{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
  fixDarwinDylibNames,
}:

stdenv.mkDerivation rec {
  pname = "capstone";
  version = "4.0.2";

  src = fetchFromGitHub {
    owner = "capstone-engine";
    repo = "capstone";
    rev = version;
    sha256 = "sha256-XMwQ7UaPC8YYu4yxsE4bbR3leYPfBHu5iixSLz05r3g=";
  };

  nativeBuildInputs = [
    cmake
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    fixDarwinDylibNames
  ];

  doCheck = true;

  # CMake 2.6 is deprecated and is no longer supported by CMake > 4
  # https://github.com/NixOS/nixpkgs/issues/445447
  postPatch = ''
    substituteInPlace CMakeLists.txt --replace-fail \
      "cmake_minimum_required(VERSION 2.6)"  \
      "cmake_minimum_required(VERSION 3.10)" \
    --replace-fail \
      "cmake_policy (SET CMP0048 OLD)" \
      "cmake_policy (SET CMP0048 NEW)"
  '';

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

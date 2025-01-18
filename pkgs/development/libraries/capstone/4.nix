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

  nativeBuildInputs =
    [
      cmake
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      fixDarwinDylibNames
    ];

  doCheck = true;

  meta = with lib; {
    description = "Advanced disassembly library";
    homepage = "http://www.capstone-engine.org";
    license = licenses.bsd3;
    maintainers = with maintainers; [
      thoughtpolice
      ris
    ];
    mainProgram = "cstool";
    platforms = platforms.unix;
  };
}

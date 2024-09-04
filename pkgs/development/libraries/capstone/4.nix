{ lib
, stdenv
, cmake
, fetchFromGitHub
, fixDarwinDylibNames
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

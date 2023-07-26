{ lib
, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "yyjson";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "ibireme";
    repo = "yyjson";
    rev = finalAttrs.version;
    hash = "sha256-Cz8K+cWuDpoMY6d+ecuOvXIMc4wtx15LLvxpFibkNyw=";
  };

  nativeBuildInputs = [
    cmake
  ];

  meta = with lib; {
    description = "The fastest JSON library in C";
    homepage = "https://github.com/ibireme/yyjson";
    changelog = "https://github.com/ibireme/yyjson/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ federicoschonborn ];
  };
})

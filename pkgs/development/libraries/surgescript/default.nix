{ lib
, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "surgescript";
  version = "0.5.6.1";

  src = fetchFromGitHub {
    owner = "alemart";
    repo = "surgescript";
    rev = "v${version}";
    hash = "sha256-0mgfam1zJfDGG558Vo1TysE2ehPD30XCP/j3GMnqN9w=";
  };

  nativeBuildInputs = [
    cmake
  ];

  meta = with lib; {
    description = "SurgeScript: a scripting language for games";
    homepage = "https://docs.opensurge2d.org/";
    changelog = "https://github.com/alemart/surgescript/blob/${src.rev}/CHANGES.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ federicoschonborn ];
  };
}

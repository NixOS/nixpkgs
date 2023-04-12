{ lib, buildNimPackage, fetchFromGitHub }:

buildNimPackage rec {
  pname = "tempfile";
  version = "0.1.7";
  src = fetchFromGitHub {
    owner = "OpenSystemsLab";
    repo = "${pname}.nim";
    rev = version;
    hash = "sha256-08vvHXVxL1mAcpMzosaHd2FupTJrKJP5JaVcgxN4oYE=";
  };
  doCheck = false; # impure
  meta = with lib;
    src.meta // {
      description = "Temporary files and folders";
      license = [ lib.licenses.mit ];
      maintainers = [ maintainers.ehmry ];
      mainProgram = "tempfile_seeder";
    };
}

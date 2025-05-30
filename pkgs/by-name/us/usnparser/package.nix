{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication {
  pname = "usnparser";
  version = "4.1.6";

  src = fetchFromGitHub {
    owner = "PoorBillionaire";
    repo = "USN-Journal-Parser";
    rev = "3f10012215223fc1e03a48c08019cc87c45581cf";
    hash = "sha256-j8i9TYwtc5P4epeJmcvAOP5SoNEvmT1EPM2Zo7VZNnk=";
  };

  meta = {
    description = "A Python script to parse the NTFS USN Journal";
    homepage = "https://github.com/PoorBillionaire/USN-Journal-Parser";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ mikehorn ];
    mainProgram = "usn";
  };
}

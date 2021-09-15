{ lib
, fetchFromGitHub
, buildPythonPackage
, installShellFiles
}:

buildPythonPackage rec {
  pname = "me-cleaner";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "corna";
    repo = "me_cleaner";
    rev = "v${version}";
    sha256 = "sha256-RPamgHP2vQcsF4wWJcOBrzDdgUFbH7sDITmOUCkTsq0=";
  };

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = ''
    installManPage man/me_cleaner.1
  '';

  meta = with lib; {
    description = "Tool for partial deblobbing of Intel ME/TXE firmware images";
    homepage = "https://github.com/corna/me_cleaner/wiki";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ tnias ];
  };
}

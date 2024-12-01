{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  urllib3,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "downloader-cli";
  version = "0.3.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "deepjyoti30";
    repo = "downloader-cli";
    rev = "refs/tags/${version}";
    hash = "sha256-E2K3n9qCQofm4gXu1l7/0iMoJsniuzhsBUplr4aZ39s=";
  };

  propagatedBuildInputs = [ urllib3 ];

  # Disable checks due to networking (Errno 101)
  doCheck = false;

  pythonImportsCheck = [ "downloader_cli" ];

  meta = with lib; {
    description = "Downloader with an awesome customizable progressbar";
    mainProgram = "dw";
    homepage = "https://github.com/deepjyoti30/downloader-cli";
    changelog = "https://github.com/deepjyoti30/downloader-cli/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ j0hax ];
  };
}

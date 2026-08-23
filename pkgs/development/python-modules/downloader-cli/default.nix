{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  urllib3,
}:

buildPythonPackage rec {
  pname = "downloader-cli";
  version = "2019.11.15";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "deepjyoti30";
    repo = "downloader-cli";
    tag = version;
    hash = "sha256-2dH033mhV0WI84n9vcXYX1hBckKj3I+N/4TG3x/WoVE=";
  };

  propagatedBuildInputs = [ urllib3 ];

  # Disable checks due to networking (Errno 101)
  doCheck = false;

  pythonImportsCheck = [ "downloader_cli" ];

  meta = {
    description = "Downloader with an awesome customizable progressbar";
    mainProgram = "dw";
    homepage = "https://github.com/deepjyoti30/downloader-cli";
    changelog = "https://github.com/deepjyoti30/downloader-cli/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ j0hax ];
  };
}

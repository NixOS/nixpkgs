{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  requests,
  beautifulsoup4,
  feather-format,
  joblib,
  openpyxl,
  pandas,
  pyarrow,
  xlrd,
}:

buildPythonPackage rec {
  pname = "nemosis";
  version = "3.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "UNSW-CEEM";
    repo = "NEMOSIS";
    tag = "v${version}";
    hash = "sha256-vvDASzZvcDx36PnfbAvBi4mlIjBQJFVWv43V2LzGd9g=";
  };

  build-system = [ setuptools ];
  dependencies = [
    beautifulsoup4
    feather-format
    joblib
    openpyxl
    pandas
    pyarrow
    requests
    xlrd
  ];

  pythonImportsCheck = [ "nemosis" ];
  doCheck = false; # require network and patching

  meta = {
    description = "Downloader of historical data published by the Australian Energy Market Operator";
    homepage = "https://github.com/UNSW-CEEM/NEMOSIS";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}

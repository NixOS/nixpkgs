{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
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
  version = "3.8.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "UNSW-CEEM";
    repo = "NEMOSIS";
    tag = "v${version}";
    hash = "sha256-4Bb9yZUfwkFQVNSVGtg3APXPovos23oHAx4v+6aa7MM=";
  };

  build-system = [ hatchling ];
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

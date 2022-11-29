{ buildPythonPackage
, fetchFromGitHub
, requests
, click
, lib
}:

buildPythonPackage rec {
  pname = "cvelib";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "RedHatProductSecurity";
    repo = "cvelib";
    rev = "tags/${version}";
    sha256 = "sha256-KUj9Cnvl7r8NMmZvVj5CB0uZvLNK5aHcLc+NzxFrv0I=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = "v${version}";
  propagatedBuildInputs = [ requests click ];

  pythonImportsCheck = [
    "cvelib"
  ];

  meta = with lib; {
    description = "A library and a command line interface for the CVE Services API";
    homepage = "https://github.com/RedHatProductSecurity/cvelib";
    license = licenses.mit;
    maintainers = with maintainers; [ raboof ];
  };
}

{ lib
, buildPythonPackage
, fetchFromGitHub
, isPy3k
, simplejson
, psutil
}:

buildPythonPackage rec {
  pname = "le";
  version = "1.4.29";

  src = fetchFromGitHub {
    owner = "logentries";
    repo = "le";
    rev = "v${version}";
    sha256 = "sha256-67JPnof0olReu90rM78e1px8NvbGcj8pphFhPaiSVmA=";
  };

  disabled = isPy3k;

  doCheck = false;

  propagatedBuildInputs = [ simplejson psutil ];

  meta = with lib; {
    homepage = "https://github.com/rapid7/le";
    description = "Logentries agent";
    license = licenses.mit;
  };

}

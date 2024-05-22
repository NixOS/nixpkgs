{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  requests,
}:

buildPythonPackage rec {
  pname = "pynamecheap";
  version = "0.0.3";

  propagatedBuildInputs = [ requests ];

  # Tests require access to api.sandbox.namecheap.com
  doCheck = false;

  src = fetchFromGitHub {
    owner = "Bemmu";
    repo = "PyNamecheap";
    rev = "v${version}";
    sha256 = "1g1cd2yc6rpdsc5ax7s93y5nfkf91gcvbgcaqyl9ida6srd9hr97";
  };

  meta = with lib; {
    description = "Namecheap API client in Python.";
    homepage = "https://github.com/Bemmu/PyNamecheap";
    license = licenses.mit;
  };
}

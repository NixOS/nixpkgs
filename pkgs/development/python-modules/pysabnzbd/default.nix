{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  aiohttp,
}:

buildPythonPackage rec {
  pname = "pysabnzbd";
  version = "1.1.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "jeradM";
    repo = "pysabnzbd";
    rev = "8e6cd1869c8cc99a4560ea1b178f0a1efd89e460"; # tag is missing
    hash = "sha256-Ubl+kdcjMm1A7pa3Q5G+fFBwPIxA375Ci04/vVyUl+A=";
  };

  propagatedBuildInputs = [ aiohttp ];

  # upstream has no tests
  doCheck = false;

  pythonImportsCheck = [ "pysabnzbd" ];

  meta = {
    description = "Python wrapper for SABnzbd API";
    homepage = "https://github.com/jeradM/pysabnzbd";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}

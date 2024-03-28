{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, setuptools
, setuptools-scm
, wheel
}:

buildPythonPackage rec {
  pname = "astropy-iers-data";
  version = "0.2024.03.25.00.29.50";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "astropy";
    repo = "astropy-iers-data";
    rev = "refs/tags/v${version}";
    hash = "sha256-QdyMEej7eBxpQTYCYUNMKZ7O/BC7Y26KGAiKqYSzI4E=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
    wheel
  ];

  pythonImportsCheck = [ "astropy_iers_data" ];

  # no tests
  doCheck = false;

  meta = with lib; {
    description = "IERS data maintained by @astrofrog and astropy.utils.iers maintainers";
    homepage = "https://github.com/astropy/astropy-iers-data";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}

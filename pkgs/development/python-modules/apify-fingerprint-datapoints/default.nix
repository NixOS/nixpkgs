# pkgs/development/python-modules/apify-fingerprint-datapoints/default.nix

{
  lib,
  buildPythonPackage,
  # fetchPypi,
  hatchling,
  setuptools,
  fetchurl,
}:

buildPythonPackage {
  pname = "apify-fingerprint-datapoints";
  version = "0.1.0";
  format = "pyproject";

  # src = fetchPypi {
  #   inherit pname version;
  #   hash = "sha256-sF7N7RiSli4yGWzH0cS66GRtNS3k/te8u8OOnGvNQTY=";
  # };

  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/63/7d/355f0d8ac50d03e0877a071deacecb3297d59a52fd2ecf1fab6c9d9474e9/apify_fingerprint_datapoints-0.1.0.tar.gz";
    hash = "sha256-sF7N7RiSli4yGWzH0cS66GRtNS3k/te8u8OOnGvNQTY=";
  };

  nativeBuildInputs = [
    hatchling
    setuptools
  ];

  # It's good practice to run tests if they are available and work offline.
  # Since you set doCheck = false, we'll keep it that way for now.
  doCheck = false;

  pythonImportsCheck = [ "apify_fingerprint_datapoints" ];

  meta = with lib; {
    description = "Fingerprint datapoints files collected by Apify and originally stored at https://github.com/apify/fingerprint-suite. This package contains datafiles and helper functions for getting the path to the datafiles.";
    homepage = "https://docs.apify.com/academy/anti-scraping/techniques/fingerprinting";
    license = licenses.asl20;
    maintainers = with maintainers; [ monk3yd ];
  };
}

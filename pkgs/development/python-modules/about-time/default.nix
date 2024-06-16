{
  lib,
  fetchPypi,
  buildPythonPackage,
}:

buildPythonPackage rec {
  pname = "about-time";
  version = "4.2.1";
  format = "setuptools";

  # PyPi release does not contain test files, but the repo has no release tags,
  # so while having no tests is not ideal, follow the PyPi releases for now
  # TODO: switch to fetchFromGitHub once this issue is fixed:
  # https://github.com/rsalmei/about-time/issues/15
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-alOIYtM85n2ZdCnRSZgxDh2/2my32bv795nEcJhH/s4=";
  };

  doCheck = false;

  pythonImportsCheck = [ "about_time" ];

  meta = with lib; {
    description = "A cool helper for tracking time and throughput of code blocks, with beautiful human friendly renditions";
    homepage = "https://github.com/rsalmei/about-time";
    license = licenses.mit;
    maintainers = with maintainers; [ thiagokokada ];
  };
}

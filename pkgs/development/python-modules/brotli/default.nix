{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook }:

buildPythonPackage rec {
  pname = "brotli";
  version = "1.0.9";

  # PyPI doesn't contain tests so let's use GitHub
  src = fetchFromGitHub {
    owner = "google";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-tFnXSXv8t3l3HX6GwWLhEtgpqz0c7Yom5U3k47pWM7o=";
    # for some reason, the test data isn't captured in releases, force a git checkout
    forceFetchGit = true;
  };

  dontConfigure = true;

  checkInputs = [
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "python/tests"
  ];

  meta = with lib; {
    homepage = "https://github.com/google/brotli";
    description = "Generic-purpose lossless compression algorithm";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}

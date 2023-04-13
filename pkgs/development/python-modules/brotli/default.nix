{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "brotli";
  version = "1.0.9";

  src = fetchFromGitHub {
    owner = "google";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-tFnXSXv8t3l3HX6GwWLhEtgpqz0c7Yom5U3k47pWM7o=";
    # .gitattributes is not correct or GitHub does not parse it correct and the archive is missing the test data
    forceFetchGit = true;
  };

  # only returns information how to really build
  dontConfigure = true;

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "python/tests"
  ];

  meta = with lib; {
    homepage = "https://github.com/google/brotli";
    description = "Generic-purpose lossless compression algorithm";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}

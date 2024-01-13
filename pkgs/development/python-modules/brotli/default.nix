{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "brotli";
  version = "1.1.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "google";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-MvceRcle2dSkkucC2PlsCizsIf8iv95d8Xjqew266wc=";
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
    maintainers = with maintainers; [ ];
  };
}

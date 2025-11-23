{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-cov-stub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "podcastparser";
  version = "0.6.11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "gpodder";
    repo = "podcastparser";
    tag = version;
    hash = "sha256-eF/YHKSCMZnavkoX3LcAFHPSPABijn+aPVzaeRYY3WI=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "podcastparser" ];

  meta = with lib; {
    description = "Module to parse podcasts";
    homepage = "http://gpodder.org/podcastparser/";
    changelog = "https://github.com/gpodder/podcastparser/releases/tag/${src.tag}";
    license = licenses.bsd2;
    maintainers = with maintainers; [ mic92 ];
  };
}

{
  lib,
  buildPythonPackage,
  fetchPypi,
  mopidy,
  setuptools,
  cachetools,
  uritools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "mopidy-podcast";
  version = "3.0.1";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "Mopidy-Podcast";
    hash = "sha256-grNPVEVM2PlpYhBXe6sabFjWVB9+q+apIRjcHUxH52A=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    mopidy
    cachetools
    uritools
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "mopidy_podcast" ];

  meta = with lib; {
    homepage = "https://github.com/tkem/mopidy-podcast";
    description = "Mopidy extension for browsing and playing podcasts";
    license = licenses.asl20;
    maintainers = [
      maintainers.daneads
    ];
  };
}

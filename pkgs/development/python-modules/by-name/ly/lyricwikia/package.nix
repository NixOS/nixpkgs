{
  lib,
  beautifulsoup4,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  requests,
  responses,
  six,
}:

buildPythonPackage rec {
  pname = "lyricwikia";
  version = "0.1.11";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "enricobacis";
    repo = "lyricwikia";
    tag = version;
    hash = "sha256-P88DrRAa2zptt8JLy0/PLi0oZ/BghF/XGSP0kOObi7E=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "'pytest-runner'" ""
  '';

  propagatedBuildInputs = [
    beautifulsoup4
    requests
    six
  ];

  nativeCheckInputs = [
    pytestCheckHook
    responses
  ];

  pythonImportsCheck = [ "lyricwikia" ];

  disabledTests = [
    # Test requires network access
    "test_integration"
  ];

  meta = {
    description = "LyricWikia API for song lyrics";
    mainProgram = "lyrics";
    homepage = "https://github.com/enricobacis/lyricwikia";
    changelog = "https://github.com/enricobacis/lyricwikia/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kmein ];
  };
}

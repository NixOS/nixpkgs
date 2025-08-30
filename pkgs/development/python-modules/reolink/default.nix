{
  lib,
  aiohttp,
  aiounittest,
  buildPythonPackage,
  fetchFromGitHub,
  ffmpeg-python,
  pytestCheckHook,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "reolink";
  version = "0.64";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fwestenberg";
    repo = "reolink";
    tag = "v${version}";
    hash = "sha256-3r5BwVlNolji2HIGjqv8gkizx4wWxrKYkiNmSJedKmI=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    ffmpeg-python
    requests
  ];

  nativeCheckInputs = [
    aiounittest
    pytestCheckHook
  ];

  postPatch = ''
    # Packages in nixpkgs is different than the module name
    substituteInPlace setup.py \
      --replace "ffmpeg" "ffmpeg-python"
  '';

  # https://github.com/fwestenberg/reolink/issues/83
  doCheck = false;

  enabledTestPaths = [ "test.py" ];

  disabledTests = [
    # Tests require network access
    "test1_settings"
    "test2_states"
    "test3_images"
    "test4_properties"
    "test_succes"
  ];

  pythonImportsCheck = [ "reolink" ];

  passthru.skipBulkUpdate = true;

  meta = with lib; {
    description = "Module to interact with the Reolink IP camera API";
    homepage = "https://github.com/fwestenberg/reolink";
    changelog = "https://github.com/fwestenberg/reolink/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}

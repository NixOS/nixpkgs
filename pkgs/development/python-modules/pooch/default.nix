{
  lib,
  buildPythonPackage,
  isPy27,
  fetchPypi,
  setuptools,
  setuptools-scm,
  wheel,
  pytestCheckHook,
  packaging,
  platformdirs,
  requests,
  tqdm,
  paramiko,
  xxhash,
}:

buildPythonPackage rec {
  pname = "pooch";
  version = "1.8.2";
  format = "pyproject";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-dlYfDeaKAdpN9q846ZVcTJ0aXJDac/fkAnalco7IPRA=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
    wheel
  ];

  propagatedBuildInputs = [
    packaging
    platformdirs
    requests
  ];

  passthru = {
    optional-dependencies = {
      progress = [ tqdm ];
      sftp = [ paramiko ];
      xxhash = [ xxhash ];
    };
  };
  preCheck = ''
    export HOME=$TMPDIR
  '';

  nativeCheckInputs = [ pytestCheckHook ];

  # tries to touch network
  disabledTests = [
    "check_availability"
    "decompress"
    "downloader"
    "extractprocessor_fails"
    "integration"
    "pooch_corrupted"
    "pooch_custom_url"
    "pooch_download"
    "pooch_logging_level"
    "pooch_update"
    "processor"
    "test_fetch"
    "test_load_registry_from_doi"
    "test_retrieve"
    "test_stream_download"
  ];

  meta = with lib; {
    description = "Friend to fetch your data files";
    homepage = "https://github.com/fatiando/pooch";
    license = licenses.bsd3;
    maintainers = with maintainers; [ GuillaumeDesforges ];
  };
}

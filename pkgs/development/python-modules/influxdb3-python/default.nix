{
  lib,
  buildPythonPackage,
  certifi,
  fetchFromGitHub,
  pyarrow,
  python-dateutil,
  reactivex,
  setuptools,
  pandas,
  polars,
  urllib3,
}:

buildPythonPackage (finalAttrs: {
  pname = "influxdb3-python";
  version = "0.17.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "InfluxCommunity";
    repo = "influxdb3-python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DqCA0sk5xOQTFoJR+b/r+PN9bJaWSkgsFUK1o1qaAoU=";
  };

  postPatch = ''
    # Upstream falls back to a default version if not in a GitHub Actions
    substituteInPlace setup.py \
      --replace-fail "version=get_version()," "version = '${finalAttrs.version}',"
  '';

  build-system = [ setuptools ];

  dependencies = [
    certifi
    pyarrow
    python-dateutil
    reactivex
    urllib3
  ];

  optional-dependencies = {
    pandas = [ pandas ];
    polars = [ polars ];
    dataframe = [
      pandas
      polars
    ];
  };

  # Missing ORC support
  # https://github.com/NixOS/nixpkgs/issues/212863
  # nativeCheckInputs = [
  #   pytestCheckHook
  # ];
  #
  # pythonImportsCheck = [
  #   "influxdb_client_3"
  # ];

  meta = {
    description = "Python module that provides a simple and convenient way to interact with InfluxDB 3.0";
    homepage = "https://github.com/InfluxCommunity/influxdb3-python";
    changelog = "https://github.com/InfluxCommunity/influxdb3-python/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})

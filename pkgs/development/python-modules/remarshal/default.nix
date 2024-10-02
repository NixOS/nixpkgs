{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build deps
  poetry-core,

  # propagates
  cbor2,
  python-dateutil,
  pyyaml,
  tomlkit,
  u-msgpack-python,

  # tested using
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "remarshal";
  version = "0.18.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "dbohdan";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-GFQzeFAHofGohOpsMg7cORyKM1iterwMWD+J7LGQzdk=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  pythonRelaxDeps = [ "pytest" ];

  propagatedBuildInputs = [
    cbor2
    python-dateutil
    pyyaml
    tomlkit
    u-msgpack-python
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    changelog = "https://github.com/remarshal-project/remarshal/releases/tag/v${version}";
    description = "Convert between TOML, YAML and JSON";
    license = licenses.mit;
    homepage = "https://github.com/dbohdan/remarshal";
    maintainers = with maintainers; [ offline ];
  };
}

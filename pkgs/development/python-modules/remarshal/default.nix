{ lib
, buildPythonApplication
, fetchFromGitHub

# build deps
, poetry-core

# propagates
, cbor2
, python-dateutil
, pyyaml
, tomlkit
, u-msgpack-python

# tested using
, pytestCheckHook
}:

buildPythonApplication rec {
  pname = "remarshal";
  version = "0.14.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "dbohdan";
    repo = pname;
    rev = "v${version}";
    hash = "sha256:nTM3jrPf0kGE15J+ZXBIt2+NGSW2a6VlZCKj70n5kHM=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "poetry.masonry.api" "poetry.core.masonry.api" \
      --replace 'PyYAML = "^5.3"' 'PyYAML = "*"' \
      --replace 'tomlkit = "^0.7"' 'tomlkit = "*"'
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    cbor2
    python-dateutil
    pyyaml
    tomlkit
    u-msgpack-python
  ];

  checkInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Convert between TOML, YAML and JSON";
    license = licenses.mit;
    homepage = "https://github.com/dbohdan/remarshal";
    maintainers = with maintainers; [ offline ];
  };
}

{
  lib,
  buildPythonPackage,
  deprecat,
  dnspython,
  fetchFromGitHub,
  loguru,
  passlib,
  poetry-core,
  pytestCheckHook,
  pythonOlder,
  pythonRelaxDepsHook,
  toml,
}:

buildPythonPackage rec {
  pname = "ciscoconfparse";
  version = "1.7.24";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mpenning";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-vL/CQdYcOP356EyRToviWylP1EBtxmeov6qkhfQNZ2Y=";
  };

  pythonRelaxDeps = [ "loguru" ];

  postPatch = ''
    # The line below is in the [build-system] section, which is invalid and
    # rejected by PyPA's build tool. It belongs in [project] but upstream has
    # had problems with putting that there (see comment in pyproject.toml).
    sed -i '/requires-python/d' pyproject.toml

    substituteInPlace pyproject.toml \
      --replace '"poetry>=1.3.2",' ""

    patchShebangs tests
  '';

  nativeBuildInputs = [
    poetry-core
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = [
    passlib
    deprecat
    dnspython
    loguru
    toml
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestPaths = [ "tests/parse_test.py" ];

  disabledTests = [
    # Tests require network access
    "test_dns_lookup"
    "test_reverse_dns_lookup"
    # Path issues with configuration files
    "testParse_valid_filepath"
  ];

  pythonImportsCheck = [ "ciscoconfparse" ];

  meta = with lib; {
    description = "Module to parse, audit, query, build, and modify Cisco IOS-style configurations";
    homepage = "https://github.com/mpenning/ciscoconfparse";
    changelog = "https://github.com/mpenning/ciscoconfparse/blob/${version}/CHANGES.md";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ astro ];
  };
}

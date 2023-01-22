{ lib
, ansible
, ansible-core
, anyconfig
, appdirs
, buildPythonPackage
, colorama
, fetchFromGitHub
, flake8
, jsonschema
, nested-lookup
, pathspec
, poetry-core
, pytest-mock
, python-json-logger
, pytestCheckHook
, pythonRelaxDepsHook
, pythonOlder
, pyyaml
, toolz
, unidiff
, yamllint
}:

buildPythonPackage rec {
  pname = "ansible-later";
  version = "3.1.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "thegeeklab";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-Mi8CJ3OU27zJ2PNkrqu0BytTI5ZaQezi8DIW3yXCzDI=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'version = "0.0.0"' 'version = "${version}"' \
      --replace " --cov=ansiblelater --cov-report=xml:coverage.xml --cov-report=term --cov-append --no-cov-on-fail" ""
  '';

  pythonRelaxDeps = [
    "flake8"
    "jsonschema"
    "pathspec"
    "python-json-logger"
    "pyyaml"
    "toolz"
    "unidiff"
    "yamllint"
  ];

  nativeBuildInputs = [
    poetry-core
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = [
    ansible
    ansible-core
    anyconfig
    appdirs
    colorama
    flake8
    jsonschema
    nested-lookup
    pathspec
    python-json-logger
    pyyaml
    toolz
    unidiff
    yamllint
  ];

  nativeCheckInputs = [
    pytest-mock
    pytestCheckHook
  ];

  postInstall = ''
    rm $out/lib/python*/site-packages/LICENSE
  '';

  pythonImportsCheck = [
    "ansiblelater"
  ];

  meta = with lib; {
    description = "Best practice scanner for Ansible roles and playbooks";
    homepage = "https://github.com/thegeeklab/ansible-later";
    changelog = "https://github.com/thegeeklab/ansible-later/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ tboerger ];
  };
}

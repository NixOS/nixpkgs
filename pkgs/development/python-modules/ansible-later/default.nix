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
, pythonOlder
, pyyaml
, toolz
, unidiff
, yamllint
}:

buildPythonPackage rec {
  pname = "ansible-later";
  version = "2.0.16";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "thegeeklab";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-AlLy8rqqNrJtoI01OHq8W1Oi8iN8RiBdtq2sZ7zlTyM=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'version = "0.0.0"' 'version = "${version}"' \
      --replace " --cov=ansiblelater --cov-report=xml:coverage.xml --cov-report=term --cov-append --no-cov-on-fail" "" \
      --replace 'PyYAML = "6.0"' 'PyYAML = "*"' \
      --replace 'unidiff = "0.7.3"' 'unidiff = "*"' \
      --replace 'jsonschema = "' 'jsonschema = "^' \
      --replace 'python-json-logger = "' 'python-json-logger = "^' \
      --replace 'toolz = "0.11.2' 'toolz = "*' \
      --replace 'yamllint = "' 'yamllint = "^'
  '';

  nativeBuildInputs = [
    poetry-core
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

  checkInputs = [
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
    license = licenses.mit;
    maintainers = with maintainers; [ tboerger ];
  };
}

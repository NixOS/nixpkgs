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
  version = "2.0.19";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "thegeeklab";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-kyoNuykPWdH8uHxjl0nWVwyFYLeWjbtOTkEZ1fG7x5E=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'version = "0.0.0"' 'version = "${version}"' \
      --replace " --cov=ansiblelater --cov-report=xml:coverage.xml --cov-report=term --cov-append --no-cov-on-fail" "" \
      --replace 'jsonschema = "4.14.0"' 'jsonschema = "*"'
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

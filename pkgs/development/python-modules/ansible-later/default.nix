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
    rev = "v${version}";
    hash = "sha256-kyoNuykPWdH8uHxjl0nWVwyFYLeWjbtOTkEZ1fG7x5E=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'version = "0.0.0"' 'version = "${version}"' \
      --replace 'jsonschema = "' 'jsonschema = "^' \
      --replace "--cov=ansiblelater --cov-report=xml:coverage.xml --cov-report=term --cov-append --no-cov-on-fail" "" \
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
    description = "Another best practice scanner for Ansible roles and playbooks";
    longDescription = ''
      ansible-later is a best practice scanner and linting tool. In most cases,
      if you write Ansible roles in a team, it helps to have a coding or best
      practice guideline in place. This will make Ansible roles more readable
      for all maintainers and can reduce the troubleshooting time. While
      ansible-later aims to be a fast and easy to use linting tool for your
      Ansible resources, it might not be that feature completed as required in
      some situations. If you need a more in-depth analysis you can take a look
      at ansible-lint.
    '';
    homepage = "https://github.com/thegeeklab/ansible-later";
    license = licenses.mit;
    maintainers = with maintainers; [ azahi tboerger ];
  };
}

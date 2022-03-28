{ buildPythonPackage
, fetchFromGitHub
, lib

# pythonPackages
, anyconfig
, appdirs
, colorama
, flake8
, jsonschema
, nested-lookup
, poetry-core
, python-json-logger
, pyyaml
, toolz
, unidiff
, yamllint
}:

buildPythonPackage rec {
  pname = "ansible-later";
  version = "2.0.6";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "thegeeklab";
    repo = "ansible-later";
    rev = "v${version}";
    sha256 = "sha256-vg9ryzl9ZeOGuFLL1yeJ3vGNPdo3ONmCQozY6DK6miY=";
  };

  postInstall = ''
    rm $out/lib/python*/site-packages/LICENSE
  '';

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'PyYAML = "6.0"' 'PyYAML = "*"' \
      --replace 'unidiff = "0.7.3"' 'unidiff = "*"' \
      --replace 'jsonschema = "4.4.0"' 'jsonschema = "*"'
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    anyconfig
    appdirs
    colorama
    flake8
    jsonschema
    nested-lookup
    python-json-logger
    pyyaml
    toolz
    unidiff
    yamllint
  ];

  # no tests
  doCheck = false;
  pythonImportsCheck = [ "ansiblelater" ];

  meta = with lib; {
    description = "Another best practice scanner for Ansible roles and playbooks";
    homepage = "https://github.com/thegeeklab/ansible-later";
    license = licenses.mit;
    maintainers = with maintainers; [ tboerger ];
  };
}

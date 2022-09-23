{ lib
, anyconfig
, appdirs
, buildPythonPackage
, colorama
, environs
, fetchFromGitHub
, jinja2
, jsonschema
, nested-lookup
, pathspec
, poetry-core
, python-json-logger
, pythonOlder
, ruamel-yaml
}:

buildPythonPackage rec {
  pname = "ansible-doctor";
  version = "1.4.4";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "thegeeklab";
    repo = "ansible-doctor";
    rev = "refs/tags/v${version}";
    hash = "sha256-blCBlSCp7W6tlCa5381ex7yq37iY9v6u7ITHmJEUxl0=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    anyconfig
    appdirs
    colorama
    environs
    jinja2
    jsonschema
    nested-lookup
    pathspec
    python-json-logger
    ruamel-yaml
  ];

  postInstall = ''
    rm $out/lib/python*/site-packages/LICENSE
  '';

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'jsonschema = "4.15.0"' 'jsonschema = "*"' \
      --replace 'nested-lookup = "0.2.25"' 'nested-lookup = "*"' \
      --replace 'pathspec = "0.10.1"' 'pathspec = "*"'
  '';

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "ansibledoctor"
  ];

  meta = with lib; {
    description = "Annotation based documentation for your Ansible roles";
    homepage = "https://github.com/thegeeklab/ansible-doctor";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ tboerger ];
  };
}

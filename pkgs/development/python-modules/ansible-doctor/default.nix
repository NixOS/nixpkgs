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
, pythonRelaxDepsHook
, ruamel-yaml
}:

buildPythonPackage rec {
  pname = "ansible-doctor";
  version = "1.4.8";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "thegeeklab";
    repo = "ansible-doctor";
    rev = "refs/tags/v${version}";
    hash = "sha256-A4SqDEArnRG9SJTqU/C9TOQO2vjot+hfj2/PKB/JMfw=";
  };

  pythonRelaxDeps = true;

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'version = "0.0.0"' 'version = "${version}"'
  '';

  nativeBuildInputs = [
    poetry-core
    pythonRelaxDepsHook
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

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "ansibledoctor"
  ];

  meta = with lib; {
    description = "Annotation based documentation for your Ansible roles";
    homepage = "https://github.com/thegeeklab/ansible-doctor";
    changelog = "https://github.com/thegeeklab/ansible-doctor/releases/tag/v${version}";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ tboerger ];
  };
}

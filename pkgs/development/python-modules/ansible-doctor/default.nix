{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder

# pythonPackages
, anyconfig
, appdirs
, colorama
, environs
, jinja2
, jsonschema
, nested-lookup
, pathspec
, poetry-core
, python-json-logger
, ruamel-yaml
}:

buildPythonPackage rec {
  pname = "ansible-doctor";
  version = "1.2.4";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "thegeeklab";
    repo = "ansible-doctor";
    rev = "v${version}";
    hash = "sha256-e0FmV4U96TSC/dYJlgo5AeLdXQ7Z7rrP4JCtBxJdkhU=";
  };

  postInstall = ''
    rm $out/lib/python*/site-packages/LICENSE
  '';

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'anyconfig = "0.13.0"' 'anyconfig = "*"' \
      --replace 'environs = "9.5.0"' 'environs = "*"' \
      --replace 'jsonschema = "4.4.0"' 'jsonschema = "*"' \
      --replace '"ruamel.yaml" = "0.17.21"' '"ruamel.yaml" = "*"'
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    jinja2
    colorama
    python-json-logger
    pathspec
    environs
    jsonschema
    appdirs
    ruamel-yaml
    anyconfig
    nested-lookup
  ];

  # no tests
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

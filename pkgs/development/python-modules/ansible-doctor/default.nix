{ buildPythonPackage
, fetchFromGitHub
, lib

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
  version = "1.2.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "thegeeklab";
    repo = "ansible-doctor";
    rev = "v${version}";
    sha256 = "sha256-2Jaf7asU4c7kw9v9dUYDL4/M2Y/2qhMM3m0jqYiobUI=";
  };

  postInstall = ''
    rm $out/lib/python*/site-packages/LICENSE
  '';

  postPatch = ''
    substituteInPlace pyproject.toml \
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
  pythonImportsCheck = [ "ansibledoctor" ];

  meta = with lib; {
    description = "Annotation based documentation for your Ansible roles";
    homepage = "https://github.com/thegeeklab/ansible-doctor";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ tboerger ];
  };
}

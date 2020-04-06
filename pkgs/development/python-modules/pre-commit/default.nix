{ lib, fetchPypi, buildPythonApplication, pythonOlder
, aspy-yaml
, cached-property
, cfgv
, futures
, identify
, importlib-metadata
, importlib-resources
, nodeenv
, python
, six
, toml
, virtualenv
}:

buildPythonApplication rec {
  pname = "pre-commit";
  version = "1.21.0";

  src = fetchPypi {
    inherit version;
    pname = "pre_commit";
    sha256 = "0l5qg1cw4a0670m96s0ryy5mqz5aslfrrnwpriqgmrnsgdixhj4g";
  };

  patches = [
    ./hook-tmpl-use-the-hardcoded-path-to-pre-commit.patch
  ];

  propagatedBuildInputs = [
    aspy-yaml
    cached-property
    cfgv
    identify
    nodeenv
    six
    toml
    virtualenv
    importlib-metadata
  ] ++ lib.optional (pythonOlder "3.7") importlib-resources
    ++ lib.optional (pythonOlder "3.2") futures;

  # slow and impure
  doCheck = false;

  preFixup = ''
    substituteInPlace $out/${python.sitePackages}/pre_commit/resources/hook-tmpl \
      --subst-var-by pre-commit $out
  '';

  meta = with lib; {
    description = "A framework for managing and maintaining multi-language pre-commit hooks";
    homepage = https://pre-commit.com/;
    license = licenses.mit;
    maintainers = with maintainers; [ borisbabic ];
  };
}

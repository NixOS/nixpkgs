{ lib, fetchPypi, buildPythonPackage, pythonOlder
, aspy-yaml
, cached-property
, cfgv
, identify
, importlib-metadata
, importlib-resources
, isPy27
, nodeenv
, python
, six
, toml
, virtualenv
}:

buildPythonPackage rec {
  pname = "pre-commit";
  version = "2.11.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit version;
    pname = "pre_commit";
    sha256 = "15f1chxrbmfcajk1ngk3jvf6jjbigb5dg66wnn7phmlywaawpy06";
  };

  patches = [
    ./hook-tmpl-use-the-hardcoded-path-to-pre-commit.patch
    ./languages-use-the-hardcoded-path-to-python-binaries.patch
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
  ] ++ lib.optional (pythonOlder "3.8") importlib-metadata
    ++ lib.optional (pythonOlder "3.7") importlib-resources;

  # slow and impure
  doCheck = false;

  preFixup = ''
    substituteInPlace $out/${python.sitePackages}/pre_commit/resources/hook-tmpl \
      --subst-var-by pre-commit $out
    substituteInPlace $out/${python.sitePackages}/pre_commit/languages/python.py \
      --subst-var-by virtualenv ${virtualenv}
    substituteInPlace $out/${python.sitePackages}/pre_commit/languages/node.py \
      --subst-var-by nodeenv ${nodeenv}
  '';

  meta = with lib; {
    description = "A framework for managing and maintaining multi-language pre-commit hooks";
    homepage = "https://pre-commit.com/";
    license = licenses.mit;
    maintainers = with maintainers; [ borisbabic ];
  };
}

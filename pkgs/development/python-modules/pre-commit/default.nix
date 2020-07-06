{ lib, fetchPypi, buildPythonPackage, pythonOlder
, aspy-yaml
, cached-property
, cfgv
, futures
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
  version = "2.6.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit version;
    pname = "pre_commit";
    sha256 = "05d9635v0yzrj2848m2hn9axbvds0dymv49rlyj238v3vlzncmqn";
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

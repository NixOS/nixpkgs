{ lib, fetchPypi, buildPythonApplication, pythonOlder
, aspy-yaml
, cached-property
, cfgv
, futures
, identify
, importlib-metadata
, importlib-resources
, nodeenv
, six
, toml
, virtualenv
}:

buildPythonApplication rec {
  pname = "pre-commit";
  version = "1.18.1";

  src = fetchPypi {
    inherit version;
    pname = "pre_commit";
    sha256 = "0d9ja186g41kw3gmhbi6xjvaslz6z4xis4qn1q6jabkka6jz4qhp";
  };

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

  meta = with lib; {
    description = "A framework for managing and maintaining multi-language pre-commit hooks";
    homepage = https://pre-commit.com/;
    license = licenses.mit;
    maintainers = with maintainers; [ borisbabic ];
  };
}

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
  version = "1.20.0";

  src = fetchPypi {
    inherit version;
    pname = "pre_commit";
    sha256 = "0vmv3hrivm0sm81cn59n2pmw8h323sg4sgncl910djby2a3jc5cz";
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

{ lib
, python3
, fetchPypi
}:

python3.pkgs.buildPythonPackage rec {
  pname = "pydantic_yaml";
  version = "0.8.0"; # for bigeye_sdk
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Mk11yEwGj2T+/VkQlnqDc1IxKWyOq6DdSNcht+zK6Ns=";
  };

  nativeBuildInputs = with python3.pkgs; [
    setuptools-scm
  ];

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  postPatch = ''
    substituteInPlace setup.py \
      --replace 'version=get_version(),' 'version="${version}",'
  '';

  propagatedBuildInputs = with python3.pkgs; [
    pydantic
    ruamel-yaml
  ] ++ python3.pkgs.pydantic.optional-dependencies.email;

  # pythonImportsCheck = [
  #   "pydanticscim"
  # ];

  # no tests
  doCheck = false;

  meta = with lib; {
    description = "Adds some YAML functionality to the excellent `pydantic` library.";
    homepage = "https://pypi.org/project/pydantic-yaml/";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
  };
}

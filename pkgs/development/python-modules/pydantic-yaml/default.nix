{ lib
, python3
, fetchPypi
}:

python3.pkgs.buildPythonPackage rec {
  pname = "pydantic-yaml";
  version = "0.8.1"; # for bigeye_sdk
  format = "setuptools";

  src = fetchPypi {
    pname = "pydantic_yaml";
    inherit version;
    hash = "sha256-yRfom/Rhsdv3QcgGs9lf05bR5Ae3ACIpAQRnUTChDGE=";
  };

  nativeBuildInputs = with python3.pkgs; [
    setuptools-scm
  ];

  # SETUPTOOLS_SCM_PRETEND_VERSION = version;

  # postPatch = ''
  #   substituteInPlace setup.py \
  #     --replace 'version=get_version(),' 'version="${version}",'
  # '';

  propagatedBuildInputs = with python3.pkgs; [
    pydantic
    ruamel-yaml
  ];

  #  ++ python3.pkgs.pydantic.optional-dependencies.email
  # pythonImportsCheck = [
  #   "pydanticscim"
  # ];

  # no tests
  doCheck = false;

  meta = with lib; {
    description = "Adds some YAML functionality to the excellent `pydantic` library.";
    homepage = "https://pypi.org/project/pydantic-yaml/";
    license = licenses.asl20;
    maintainers = with maintainers; [ sree ];
  };
}

{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  pytestCheckHook,
  pyarrow,
  setuptools-scm,
}:
buildPythonPackage rec {
  pname = "geoarrow-types";
  version = "0.2.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    repo = "geoarrow-python";
    owner = "geoarrow";
    tag = "geoarrow-types-${version}";
    hash = "sha256-LySb4AsRuSirDJ73MAPpnMwPM2WFfG6X82areR4Y4lI=";
  };

  sourceRoot = "${src.name}/geoarrow-types";

  build-system = [ setuptools-scm ];

  env.SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeCheckInputs = [
    pytestCheckHook
    pyarrow
  ];

  pythonImportsCheck = [ "geoarrow.types" ];

  meta = with lib; {
    description = "PyArrow types for geoarrow";
    homepage = "https://github.com/geoarrow/geoarrow-python";
    license = licenses.asl20;
    maintainers = with maintainers; [
      cpcloud
    ];
  };
}

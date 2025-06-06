{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  jinja2,
  kubernetes,
  ruamel-yaml,
  six,
  python-string-utils,
  pytest-bdd,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "openshift";
  version = "0.13.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "openshift";
    repo = "openshift-restclient-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-uLfewj7M8KNs3oL1AM18sR/WhAR2mvBfqadyhR73FP0=";
  };

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "kubernetes ~= 12.0" "kubernetes"

    sed -i '/--cov/d' setup.cfg
  '';

  propagatedBuildInputs = [
    jinja2
    kubernetes
    python-string-utils
    ruamel-yaml
    six
  ];

  pythonImportsCheck = [ "openshift" ];

  nativeCheckInputs = [
    pytest-bdd
    pytestCheckHook
  ];

  disabledTestPaths = [
    # requires kubeconfig
    "test/integration"
  ];

  meta = with lib; {
    description = "Python client for the OpenShift API";
    homepage = "https://github.com/openshift/openshift-restclient-python";
    license = licenses.asl20;
    maintainers = with maintainers; [ teto ];
  };
}

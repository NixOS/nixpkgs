{ lib
, buildPythonPackage
, fetchFromGitHub
, jinja2
, kubernetes
, ruamel-yaml
, six
, python-string-utils
, pytest-bdd
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "openshift";
  version = "0.12.1";

  src = fetchFromGitHub {
    owner = "openshift";
    repo = "openshift-restclient-python";
    rev = "v${version}";
    sha256 = "1di55xg3nl4dwrrfw314p4mfm6593kdi7ia517v1sm6x5p4hjl78";
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

  pythonImportsCheck = ["openshift"];

  checkInputs = [
    pytest-bdd
    pytestCheckHook
  ];

  disabledTestPaths = [
    # requires docker
    "test/functional"
  ];

  meta = with lib; {
    description = "Python client for the OpenShift API";
    homepage = "https://github.com/openshift/openshift-restclient-python";
    license = licenses.asl20;
    maintainers = with maintainers; [ teto ];
  };
}

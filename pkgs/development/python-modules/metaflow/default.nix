{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  boto3,
  requests,
  setuptools,
  python,
}:

buildPythonPackage rec {
  pname = "metaflow";
<<<<<<< HEAD
  version = "2.19.15";
=======
  version = "2.19.8";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Netflix";
    repo = "metaflow";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-cVC0rHgRHla93x/2tZA6XBMLfWw6ZmEJvjeq1PhQv6M=";
=======
    hash = "sha256-WW/YETat7ayrAx9gP+javUVbz6/EW4MfrqoB5qr8iTI=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    boto3
    requests
  ];

  checkPhase = ''
    runHook preCheck

    export HOME="$TMPDIR"
    export USER="metaflow-test-user"

    pushd test/core
    ${python.interpreter} run_tests.py --num-parallel $NIX_BUILD_CORES \
      --tests FlowOptionsTest,BasicLogTest
    popd

    runHook postCheck
  '';

  pythonImportsCheck = [ "metaflow" ];

  meta = {
    description = "Open Source AI/ML Platform";
    homepage = "https://metaflow.org/";
    changelog = "https://github.com/Netflix/metaflow/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kr7x ];
  };
}

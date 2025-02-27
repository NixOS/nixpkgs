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
  version = "2.15.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Netflix";
    repo = "metaflow";
    tag = version;
    hash = "sha256-9e88rucxjgcRMOFAbHkboep9gDNeArBVi6C2Weyyz0I=";
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

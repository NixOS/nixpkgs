{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, click
, jinja2
, terminaltables
, mock
, nose
}:

buildPythonPackage rec {
  pname = "envs";
  version = "1.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ccf5cd85ddb8ed335e39ed8a22e0d23658f5a6d7da430f225e6f750c6f50ae42";
  };

  patches = [
    # https://github.com/capless/envs/pull/19
    (fetchpatch {
      url = "https://github.com/capless/envs/commit/6947043fa9120a7b17094fd43ee0e1edf808f42b.patch";
      sha256 = "0zswg8kp2g922mkc7x34ps37qli1d1mjwna2jfrbnsq2fg4mk818";
    })
  ];

  propagatedBuildInputs = [
    click
    jinja2
    terminaltables
  ];

  checkInputs = [
    mock
    nose
  ];

  checkPhase = ''
    runHook preCheck

    nosetests --with-isolation

    runHook postCheck
  '';

  meta = with lib; {
    description = "Easy access to environment variables from Python";
    homepage = "https://github.com/capless/envs";
    license = licenses.asl20;
    maintainers = with maintainers; [ peterhoeg ];
  };
}

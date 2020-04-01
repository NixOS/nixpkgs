{ buildPythonPackage
, fetchFromGitHub
, lib

, coveralls
, promise
, pytest
, pytest-benchmark
, pytest-mock
, rx
, six
}:

buildPythonPackage rec {
  pname = "graphql-core";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "graphql-python";
    repo = pname;
    rev = "v${version}";
    sha256 = "029jnwy6zbj4x7f3ffpn1gyx0w9ala9cj2g115g6aa7im3xd2jma";
  };

  propagatedBuildInputs = [
    promise
    rx
    six
  ];

  checkInputs = [
    coveralls
    pytest
    pytest-benchmark
    pytest-mock
  ];

  checkPhase = "pytest";

  configurePhase = ''
    substituteInPlace setup.py \
      --replace 'pytest-mock==1.2' 'pytest-mock==1.13.0' \
      --replace 'pytest-benchmark==3.0.0' 'pytest-benchmark==3.2.2'
  '';

  meta = with lib; {
    description = "Port of graphql-js to Python";
    homepage = "https://github.com/graphql-python/graphql-core";
    license = licenses.mit;
    maintainers = with maintainers; [
      kamadorueda
    ];
  };
}

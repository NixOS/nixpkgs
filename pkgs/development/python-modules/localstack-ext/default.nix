{ lib
, buildPythonPackage
, fetchPypi

# build-system
, setuptools
, plux

# dependencies
, cachetools
, click
, cryptography
, dill
, dnslib
, dnspython
, psutil
, python-dotenv
, pyyaml
, requests
, rich
, semver
, stevedore
, tailer

# Sensitive downstream dependencies
, localstack
}:

buildPythonPackage rec {
  pname = "localstack-ext";
  version = "3.2.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-53pbt7kNaYQRsLb+OI8gLwR3cBE18ZKLZmG4aP1/93E=";
  };

  postPatch = ''
    # Avoid circular dependency
    sed -i '/localstack>=/d' setup.cfg

    # Pip is unable to resolve attr logic, so it will emit version as 0.0.0
    substituteInPlace setup.cfg \
      --replace "version = attr: localstack_ext.__version__" "version = ${version}"
    cat setup.cfg

    substituteInPlace setup.cfg \
      --replace "dill==0.3.2" "dill~=0.3.0" \
      --replace "requests>=2.20.0,<2.26" "requests~=2.20"
  '';

  nativeBuildInputs = [
    plux
    setuptools
  ];

  propagatedBuildInputs = [
    cachetools
    click
    cryptography
    dill
    dnslib
    dnspython
    plux
    psutil
    python-dotenv
    pyyaml
    rich
    requests
    semver
    stevedore
    tailer
  ];

  pythonImportsCheck = [ "localstack_ext" ];

  # No tests in repo
  doCheck = false;

  passthru.tests = {
    inherit localstack;
  };

  meta = with lib; {
    description = "Extensions for LocalStack";
    homepage = "https://github.com/localstack/localstack";
    license = licenses.asl20;
    maintainers = with maintainers; [ jonringer ];
  };
}

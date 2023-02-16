{ lib
, buildPythonPackage
, fetchPypi
, dill
, dnslib
, dnspython
, plux
, pyaes
, python-jose
, requests
, tabulate

# Sensitive downstream dependencies
, localstack
}:

buildPythonPackage rec {
  pname = "localstack-ext";
  version = "1.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-zMGKGTKomduydhOAxfif/Caf1QJiG2mxig4a+789SJc=";
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

  propagatedBuildInputs = [
    dill
    dnslib
    dnspython
    plux
    pyaes
    python-jose
    requests
    tabulate
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

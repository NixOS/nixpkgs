{ buildPythonPackage
, fetchPypi
, isPy37
, lib

# pythonPackages
, aiohttp
, androguard
, azure-identity
, azure-keyvault-keys
, azure-keyvault-secrets
, azure-mgmt-compute
, azure-mgmt-keyvault
, azure-mgmt-network
, azure-mgmt-resource
, azure-mgmt-security
, azure-mgmt-storage
, azure-mgmt-web
, azure-storage-file
, azure-storage-file-share
, bandit
, bcrypt
, beautifulsoup4
, boto3
, cfn-flip
, cython
, dnspython
, colorama
, configobj
, defusedxml
, GitPython
, google_api_python_client
, kubernetes
, ldap3
, mixpanel
, mysql-connector
, names
, ntplib
, oyaml
, paramiko
, pillow
, psycopg2
, pycrypto
, pygments
, pyhcl
, pyjks
, pynacl
, pyopenssl
, pypdf2
, pysmb
, python_magic
, pytz
, requirements-detector
, selenium
, tlslite-ng
, viewstate

# pythonPackages to test the derivation
, pytest
}:

buildPythonPackage rec {
  pname = "fluidasserts";
  version = "20.1.33141";
  disabled = !isPy37;

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "01l6yb3r19q8b4kwqkrzn7mpfsr65zsgzax2fbs43hb6pq6vavnx";
  };

  patchPhase = ''
    # Version mismatches between current FluidAsserts and Nixpkgs
    substituteInPlace ./setup.py \
      --replace 'tlslite-ng==0.8.0-alpha36' 'tlslite-ng==0.7.5' \
      --replace 'boto3==1.11.7' 'boto3==1.10.1' \
      --replace 'cfn-flip==1.2.2' 'cfn-flip==1.1.0.post1' \
      --replace 'typed-ast==1.4.1' 'typed-ast==1.4.0' \
      --replace 'pillow==7.0.0' 'pillow==6.2.1' \

    # Functionality that will be not present for the momment
    #   but that we'll work to add in the future
    # Just a minimal portion of fluidasserts use this
    substituteInPlace ./setup.py \
      --replace "'pymssql==2.1.4'," "" \
      --replace "'pytesseract==0.3.1'," "" \
      --replace "'pywinrm==0.4.1'," "" \
      --replace "'mitmproxy==5.0.1'," "" \

  '';

  propagatedBuildInputs = [
    # pythonPackages
    aiohttp
    androguard
    azure-identity
    azure-keyvault-keys
    azure-keyvault-secrets
    azure-mgmt-compute
    azure-mgmt-keyvault
    azure-mgmt-network
    azure-mgmt-resource
    azure-mgmt-security
    azure-mgmt-storage
    azure-mgmt-web
    azure-storage-file
    azure-storage-file-share
    bandit
    bcrypt
    beautifulsoup4
    boto3
    cfn-flip
    cython
    dnspython
    colorama
    configobj
    defusedxml
    GitPython
    google_api_python_client
    kubernetes
    ldap3
    mixpanel
    mysql-connector
    names
    ntplib
    oyaml
    paramiko
    pillow
    psycopg2
    pycrypto
    pygments
    pyhcl
    pyjks
    pynacl
    pyopenssl
    pypdf2
    pysmb
    python_magic
    pytz
    requirements-detector
    selenium
    tlslite-ng
    viewstate
  ];

  checkInputs = [
    pytest
  ];

  checkPhase = ''
    # This file launches mock docker containers and servers
    #   let's remove it to create a custom test environment
    rm test/conftest.py

    pytest \
      test/test_cloud_aws_terraform_{ebs,ec2}.py \
      test/test_cloud_aws_cloudformation_{cloudfront,dynamodb,ec2,elb,elb2}.py \
      test/test_cloud_aws_cloudformation_{fsx,iam,kms,rds,s3,secretsmanager}.py \
      test/test_format_{apk,jks,jwt,pdf,pkcs12,string}.py \
      test/test_helper_{asynchronous,crypto}.py \
      test/test_lang_{javascript,java}.py \
      test/test_lang_{core,csharp,docker,dotnetconfig,html,php,python,rpgle}.py \
      test/test_utils_generic.py

  '';

  meta = with lib; {
    description = "Assertion Library for Security Assumptions";
    homepage = "https://gitlab.com/fluidattacks/asserts";
    license = licenses.mpl20;
    maintainers = with maintainers; [
      kamadorueda
    ];
  };
}

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
, azure-mgmt-storage
, azure-mgmt-web
, azure-storage-file
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
  version = "20.1.28253";
  disabled = !isPy37;

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "1d2smx9ywd1azsiwgavp69vlixmvwaabshprm192wnmprbghsp6c";
  };

  patchPhase = ''
    # Version mismatches between current FluidAsserts and Nixpkgs
    substituteInPlace ./setup.py \
      --replace 'tlslite-ng==0.8.0-alpha29' 'tlslite-ng==0.7.5' \
      --replace 'boto3==1.10.17' 'boto3==1.10.1' \
      --replace 'cfn-flip==1.2.2' 'cfn-flip==1.1.0.post1' \
      --replace 'azure-mgmt-storage==7.1.0' 'azure-mgmt-storage==7.0.0' \

    # Functionality that will be not present for the momment
    #   but that we'll work to add in the future
    # Just a minimal portion of fluidasserts use this
    substituteInPlace ./setup.py \
      --replace "'azure-storage-file-share==12.0.0'," "" \
      --replace "'pymssql==2.1.4'," "" \
      --replace "'pytesseract==0.3.0'," "" \
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
    azure-mgmt-storage
    azure-mgmt-web
    azure-storage-file
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
      test/test_cloud_aws_cloudformation_{cloudfront,dynamodb,ec2,elb,elb2}.py \
      test/test_cloud_aws_cloudformation_{fsx,iam,kms,rds,s3,secretsmanager}.py \
      test/test_format_{apk,file,jks,jwt,pdf,pkcs12,string}.py \
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

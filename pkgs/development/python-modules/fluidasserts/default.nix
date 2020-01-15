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
  version = "20.1.22554";
  disabled = !isPy37;

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "0j7zppwingi9m58z51phy40d69jlskx1vgyz1gj9miqhbjfdymhi";
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
      test/test_cloud_aws_cloudformation_cloudfront.py \
      test/test_cloud_aws_cloudformation_dynamodb.py \
      test/test_cloud_aws_cloudformation_ec2.py \
      test/test_cloud_aws_cloudformation_elb.py \
      test/test_cloud_aws_cloudformation_elb2.py \
      test/test_cloud_aws_cloudformation_fsx.py \
      test/test_cloud_aws_cloudformation_iam.py \
      test/test_cloud_aws_cloudformation_kms.py \
      test/test_cloud_aws_cloudformation_rds.py \
      test/test_cloud_aws_cloudformation_s3.py \
      test/test_cloud_aws_cloudformation_secretsmanager.py \
      test/test_format_apk.py \
      test/test_format_file.py \
      test/test_format_jks.py \
      test/test_format_jwt.py \
      test/test_format_pdf.py \
      test/test_format_pkcs12.py \
      test/test_format_string.py \
      test/test_helper_asynchronous.py \
      test/test_helper_crypto.py \
      test/test_lang_core.py \
      test/test_lang_csharp.py \
      test/test_lang_docker.py \
      test/test_lang_dotnetconfig.py \
      test/test_lang_html.py \
      test/test_lang_php.py \
      test/test_lang_python.py \
      test/test_lang_rpgle.py \

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

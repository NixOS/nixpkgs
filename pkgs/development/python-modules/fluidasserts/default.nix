{ buildPythonPackage
, fetchPypi
, isPy37
, lib

# pythonPackages
, aiohttp
, androguard
, azure-identity
, azure-keyvault
, azure-mgmt-compute
, azure-mgmt-keyvault
, azure-mgmt-network
, azure-mgmt-resource
, azure-mgmt-security
, azure-mgmt-storage
, azure-mgmt-sql
, azure-mgmt-web
, azure-storage
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
, pyodbc
, pyopenssl
, pypdf2
, pysmb
, pytesseract
, python_magic
, pytz
, pywinrm
, requirements-detector
, selenium
, tlslite-ng
, viewstate

# pythonPackages to test the derivation
, pytest
, flask
, flask-httpauth
, docker
}:

buildPythonPackage rec {
  pname = "fluidasserts";
  version = "20.2.30165";
  disabled = !isPy37;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0wcplzfx89d3c6hvdgag860sl3infqmymy6ly6y6ah77pkc98x15";
  };

  patchPhase = ''
    # Release packages from their hard pinned versions
    sed -i -E "s/(.*)==.*/\1/g" requirements.txt

    # Functionality that will be not present for the momment
    #   but that we'll work to add in the future
    # Just a minimal portion of fluidasserts use this
    substituteInPlace ./requirements.txt \
      --replace "mitmproxy" "" \

  '';

  propagatedBuildInputs = [
    # pythonPackages
    aiohttp
    androguard
    azure-identity
    azure-keyvault
    azure-mgmt-compute
    azure-mgmt-keyvault
    azure-mgmt-network
    azure-mgmt-resource
    azure-mgmt-security
    azure-mgmt-storage
    azure-mgmt-sql
    azure-mgmt-web
    azure-storage
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
    pyodbc
    pyopenssl
    pypdf2
    pysmb
    pytesseract
    python_magic
    pytz
    pywinrm
    requirements-detector
    selenium
    tlslite-ng
    viewstate
  ];

  configurePhase = ''
    mkdir -p build/config
    touch build/config/README.rst
  '';

  checkInputs = [
    docker
    flask
    flask-httpauth
    pytest
  ];

  checkPhase = ''
    # This tests require BWAPP Docker Container
    sed -ie 's/test_a[0-9]//g' ./test/test_proto_http_open.py
    sed -ie 's/test_a[0-9]//g' ./test/test_proto_http_close.py

    # This tests require network connectivity
    sed -ie 's/test_is_date_unsyncd//g' ./test/test_proto_http_open.py
    sed -ie 's/test_is_date_unsyncd//g' ./test/test_proto_http_close.py

    # Remove impurities
    substituteInPlace ./test/conftest.py \
      --replace "import wait" "" \
      --replace "if not os.path.exists(name):" "if os.path.exists(name):" \
      --replace "from test.mock import graphql_server" "" \
      --replace "(graphql_server.start, 'MockGraphQLServer', ['proto_graphql'])," "" \

    pytest --asserts-module 'iot' \
      test/test_iot_phone.py

    pytest --asserts-module 'ot' \
      test/test_ot_powerlogic.py

    pytest --asserts-module 'proto_http' \
      test/test_proto_{http_close,http_open}.py

    pytest --asserts-module 'proto_rest' \
      test/test_proto_rest.py

    # This file launches mock docker containers and servers
    #   let's remove it to create a custom test environment
    rm test/conftest.py

    pytest \
      test/test_cloud_aws_terraform_{cloudfront,dynamodb,ebs,ec2,elb}.py \
      test/test_cloud_aws_terraform_{fsx,iam,kms,rds,s3}.py \
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

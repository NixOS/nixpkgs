{ buildPythonPackage
, fetchPypi
, lib

# Python Dependencies
, pythonPackages
}:

buildPythonPackage rec {
  pname = "fluidasserts";
  version = "19.12.38711";

  src = fetchPypi {
    inherit pname version;
    format = "setuptools";
    extension = "zip";
    sha256 = "0ll29kxavb47l39kcr7p4qcdxrf8m0n1z12zn7bnq1f798kl03nb";
  };

  patchPhase = ''
    # Version mismatches between current FluidAsserts and Nix
    substituteInPlace ./setup.py \
      --replace 'colorama==0.4.1' 'colorama==0.4.3' \
      --replace 'gitpython==3.0.4' 'gitpython==3.0.5' \
      --replace 'pycrypto==2.6.1' 'pycrypto==3.9.4' \
      --replace 'pysmb==1.1.27' 'pysmb==1.1.28' \
      --replace 'tlslite-ng==0.8.0-alpha29' 'tlslite-ng==0.7.5' \

    # Functionality that will be not present for the momment
    substituteInPlace ./setup.py \
      --replace "'azure==4.0.0'," "" \
      --replace "'pytesseract==0.3.0'," "" \
  '';

  propagatedBuildInputs = with pythonPackages; [
    aiohttp
    androguard
    azure-identity
    azure-keyvault-keys
    azure-keyvault-secrets
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
    pymssql
    pynacl
    pyopenssl
    pypdf2
    pysmb
    python_magic
    pytz
    pywinrm
    requirements-detector
    selenium
    tlslite-ng
    viewstate
  ];

  doCheck = false;

  meta = {
    description = "Fluid Asserts is an engine to automate the closing of security findings over execution environments.";
    homepage = "https://gitlab.com/fluidattacks/asserts";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
      kamadorueda
    ];
  };
}

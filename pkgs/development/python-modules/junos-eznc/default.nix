{ lib
, buildPythonPackage
, fetchpatch
, fetchFromGitHub

# propagates
, jinja2
, lxml
, ncclient
, netaddr
, ntc-templates
, paramiko
, pyparsing
, pyserial
, pyyaml
, scp
, six
, transitions
, yamlordereddictloader

# tests
, mock
, nose
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "junos-eznc";
  version = "2.6.3";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Juniper";
    repo = "py-junos-eznc";
    rev = version;
    hash = "sha256-XhQJwtS518AzSwyaWE392nfNdYe9+iYHvXxQsjJfzI8=";
  };

  patches = [
    (fetchpatch {
      # Fixes tests with lxml>=4.8.0; remove > 2.6.3
      url = "https://github.com/Juniper/py-junos-eznc/commit/048f750bb7357b6f6b9db8ad64bea479298c74fb.patch";
      hash = "sha256-DYVj0BNPwDSbxDrzHhaq4F4kz1bliXB6Au3I63mRauc=";
    })
  ];

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "ncclient==0.6.9" "ncclient"
  '';

  propagatedBuildInputs = [
    jinja2
    lxml
    ncclient
    netaddr
    ntc-templates
    paramiko
    pyparsing
    pyserial
    pyyaml
    scp
    six
    transitions
    yamlordereddictloader
  ];

  checkInputs = [
    mock
    nose
  ];

  checkPhase = ''
    nosetests -v -a unit --exclude=test_sw_put_ftp
  '';

  pythonImportsCheck = [ "jnpr.junos" ];

  meta = with lib; {
    homepage = "https://github.com/Juniper/py-junos-eznc";
    description = "Junos 'EZ' automation for non-programmers";
    license = licenses.asl20;
    maintainers = with maintainers; [ xnaveira ];
  };
}

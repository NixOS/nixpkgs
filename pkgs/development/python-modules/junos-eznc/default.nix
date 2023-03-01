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
  version = "2.6.7";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Juniper";
    repo = "py-junos-eznc";
    rev = "refs/tags/${version}";
    hash = "sha256-+hGybznip5RpJm89MLg9JO4B/y50OIdgtmV2FIpZShU=";
  };

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

  nativeCheckInputs = [
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

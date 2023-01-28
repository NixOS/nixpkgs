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
  version = "2.6.6";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Juniper";
    repo = "py-junos-eznc";
    rev = "refs/tags/${version}";
    hash = "sha256-0JF9/lSIquXp25bM3GESqLC//aorSVT0hHccaOmQuM8=";
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

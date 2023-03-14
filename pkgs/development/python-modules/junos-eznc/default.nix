{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, jinja2
, lxml
, mock
, ncclient
, netaddr
, nose
, ntc-templates
, paramiko
, pyparsing
, pyserial
, pythonOlder
, pyyaml
, scp
, six
, transitions
, yamlordereddictloader
}:

buildPythonPackage rec {
  pname = "junos-eznc";
  version = "2.6.7";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Juniper";
    repo = "py-junos-eznc";
    rev = "refs/tags/${version}";
    hash = "sha256-+hGybznip5RpJm89MLg9JO4B/y50OIdgtmV2FIpZShU=";
  };

  postPatch = ''
    # https://github.com/Juniper/py-junos-eznc/issues/1236
    substituteInPlace lib/jnpr/junos/utils/scp.py \
      --replace "inspect.getargspec" "inspect.getfullargspec"
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

  nativeCheckInputs = [
    mock
    nose
  ];

  checkPhase = ''
    nosetests -v -a unit --exclude=test_sw_put_ftp
  '';

  pythonImportsCheck = [
    "jnpr.junos"
  ];

  meta = with lib; {
    changelog = "https://github.com/Juniper/py-junos-eznc/releases/tag/${version}";
    description = "Junos 'EZ' automation for non-programmers";
    homepage = "https://github.com/Juniper/py-junos-eznc";
    license = licenses.asl20;
    maintainers = with maintainers; [ xnaveira ];
  };
}

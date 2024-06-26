{ lib
, buildPythonPackage
, fetchPypi
, ddt
, installShellFiles
, openstackdocstheme
, osc-lib
, oslotest
, hacking
, pbr
, openstackclient
, requests-mock
, sphinx
, sphinxcontrib-apidoc
, stestr
,
}:

buildPythonPackage rec {
  pname = "python-octaviaclient";
  version = "3.7.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-wAGxByeRBOwdWZg2DwVpt1yGi5er3KQ/qhyRVAwaKe4=";
  };

  nativeBuildInputs = [
    installShellFiles
    openstackdocstheme
    sphinx
    sphinxcontrib-apidoc
  ];

  propagatedBuildInputs = [
    osc-lib
    pbr
    openstackclient
  ];

  # TODO: Missing module sphinxcontrib-svg2pdfconverter to build the doc
  #  postInstall = ''
  #    sphinx-build -a -E -d doc/build/doctrees -b man doc/source doc/build/man
  #    installManPage doc/build/man/openstack.1
  #'';

  nativeCheckInputs = [
    ddt
    stestr
    requests-mock
    hacking
    oslotest
  ];

  checkPhase = ''
    stestr run
  '';

  pythonImportsCheck = [ "octaviaclient" ];

  meta = with lib; {
    description = "OpenStack Octavia Command-line Client";
    homepage = "https://opendev.org/openstack/python-octaviaclient/";
    license = licenses.asl20;
    maintainers = teams.openstack.members;
  };
}


{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  cliff,
  debtcollector,
  futurist,
  iso8601,
  keystoneauth1,
  python-dateutil,
  ujson,

  # tests and doc
  flake8,
  python-openstackclient,
  pytestCheckHook,
  pytest-xdist,
  openstackdocstheme,
  sphinx,
  sphinxcontrib-apidoc,
}:

buildPythonPackage rec {
  pname = "python-gnocchiclient";
  version = "7.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "gnocchixyz";
    repo = "python-gnocchiclient";
    tag = version;
    hash = "sha256-6j33+r4ZWg04on/mIorx8sZ09wgszfQVUjgxzR6LlI8=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  nativeBuildInputs = [
    openstackdocstheme
    sphinx
    sphinxcontrib-apidoc
  ];

  dependencies = [
    cliff
    debtcollector
    futurist
    iso8601
    keystoneauth1
    python-dateutil
    ujson
  ];

  nativeCheckInputs = [
    flake8
    python-openstackclient
    pytestCheckHook
    pytest-xdist
  ];

  pythonImportsCheck = [ "gnocchiclient" ];

  meta = with lib; {
    description = "Python client library for Gnocchi";
    homepage = "https://github.com/gnocchixyz/python-gnocchiclient";
    mainProgram = "gnocchi";
    license = licenses.asl20;
    teams = [ teams.openstack ];
  };
}

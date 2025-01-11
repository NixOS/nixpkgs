{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cliff,
  oslo-i18n,
  oslo-utils,
  openstacksdk,
  pbr,
  pythonOlder,
  requests-mock,
  setuptools,
  requests,
  stestr,
}:

buildPythonPackage rec {
  pname = "osc-lib";
  version = "3.1.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "openstack";
    repo = "osc-lib";
    rev = version;
    hash = "sha256-DDjWM4hjHPXYDeAJ6FDZZPzi65DG1rJ3efs8MouX1WY=";
  };

  # fake version to make pbr.packaging happy and not reject it...
  PBR_VERSION = version;

  build-system = [
    pbr
    setuptools
  ];

  dependencies = [
    cliff
    openstacksdk
    oslo-i18n
    oslo-utils
    requests
  ];

  nativeCheckInputs = [
    requests-mock
    stestr
  ];

  checkPhase = ''
    # tests parse cli output which slightly changed
    stestr run -e <(echo "
      osc_lib.tests.utils.test_tags.TestTagHelps.test_add_tag_filtering_option_to_parser
      osc_lib.tests.utils.test_tags.TestTagHelps.test_add_tag_option_to_parser_for_create
      osc_lib.tests.utils.test_tags.TestTagHelps.test_add_tag_option_to_parser_for_set
      osc_lib.tests.utils.test_tags.TestTagHelps.test_add_tag_option_to_parser_for_unset
    ")
  '';

  pythonImportsCheck = [ "osc_lib" ];

  meta = with lib; {
    description = "OpenStackClient Library";
    homepage = "https://github.com/openstack/osc-lib";
    license = licenses.asl20;
    maintainers = teams.openstack.members;
  };
}

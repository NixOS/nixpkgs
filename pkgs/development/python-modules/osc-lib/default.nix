{ stdenv
, lib
, buildPythonPackage
, fetchFromGitHub
, cliff
, oslo-i18n
, oslo-utils
, openstacksdk
, pbr
, requests-mock
, simplejson
, stestr
}:

buildPythonPackage rec {
  pname = "osc-lib";
  version = "unstable-2022-03-09";

  src = fetchFromGitHub {
    owner = "openstack";
    repo = "osc-lib";
    rev = "65c73fd5030276e34f3d52c03ddb9d27cd8ec6f5";
    sha256 = "sha256-CLE9lrMMlvVrihe+N4wvIKe8t9IZ1TpHHVdn2dnvAOI=";
  };

  # fake version to make pbr.packaging happy and not reject it...
  PBR_VERSION = "2.5.0";

  nativeBuildInputs = [
    pbr
  ];

  propagatedBuildInputs = [
    cliff
    openstacksdk
    oslo-i18n
    oslo-utils
    simplejson
  ];

  checkInputs = [
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

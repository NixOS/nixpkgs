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
  version = "2.8.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "openstack";
    repo = "osc-lib";
    rev = version;
    hash = "sha256-ijL/m9BTAgDUjqy77nkl3rDppeUPBycmEqlL6uMruIA=";
  };

  # fake version to make pbr.packaging happy and not reject it...
  PBR_VERSION = version;

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

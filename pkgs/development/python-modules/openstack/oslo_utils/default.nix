{ lib, buildPythonApplication, fetchPypi, callPackage
, pbr, iso8601, openstack-oslo_i18n, pytz, netaddr, netifaces, openstack-debtcollector, pyparsing, packaging
}:

buildPythonApplication rec {
  pname = "openstack-oslo_utils";
  version = "4.10.0";

  src = fetchPypi {
    pname = "oslo.utils";
    inherit version;
    sha256 = "9646e6570ed08a79f21b03acfb60d32a3ac453d76304f8759b1211a59ce372cb";
  };

  propagatedBuildInputs = [
    pbr
    iso8601
    openstack-oslo_i18n
    pytz
    netaddr
    netifaces
    openstack-debtcollector
    pyparsing
    packaging
  ];

  doCheck = false;

  pythonImportsCheck = [ "oslo_utils" ];

  meta = with lib; {
    description = "Oslo utility library";
    downloadPage = "https://pypi.org/project/oslo.utils/";
    homepage = "https://github.com/openstack/oslo.utils";
    license = licenses.asl20;
    maintainers = with maintainers; [ superherointj ];
  };
}

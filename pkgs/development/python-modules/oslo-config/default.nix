{ lib, buildPythonPackage, fetchPypi, pbr, six, netaddr, stevedore, mock,
debtcollector, rfc3986, pyyaml, oslo-i18n }:

buildPythonPackage rec {
  pname = "oslo.config";
  version = "4.12.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1pa9lajsadyq47bmxx12dxlcmnqsqlgnb55hwqas26lgnb2073dx";
  };

  propagatedBuildInputs = [ pbr six netaddr stevedore debtcollector rfc3986 pyyaml oslo-i18n ];
  buildInputs = [ mock ];

  # TODO: circular import on oslo-i18n
  doCheck = false;

  postPatch = ''
    substituteInPlace requirements.txt --replace "argparse" ""
  '';

  meta = with lib; {
    description = "Oslo Configuration API";
    homepage = "https://docs.openstack.org/oslo.config/latest/";
    license = licenses.asl20;
    maintainers = with maintainers; [ makefu ];
  };


}

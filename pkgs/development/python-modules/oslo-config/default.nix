{ lib, buildPythonPackage, fetchPypi, pbr, six, netaddr, stevedore, mock,
debtcollector, rfc3986, pyyaml, oslo-i18n }:

buildPythonPackage rec {
  pname = "oslo.config";
  version = "4.13.2";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "882e5f1dcc0e5b0d7af877b2df0e2692113c5975db8cbbbf0dd3d2b905aefc0b";
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

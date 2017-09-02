{ buildPythonPackage, fetchPypi, pbr, six, netaddr, stevedore, mock }:

buildPythonPackage rec {
  pname = "oslo.config";
  version = "4.11.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1be8aaba466a3449fdb21ee8f7025b0d3d252c8c7568b8d5d05ceff58617cd05";
  };

  propagatedBuildInputs = [ pbr six netaddr stevedore ];
  buildInputs = [ mock ];

  # TODO: circular import on oslo-i18n
  doCheck = false;

  postPatch = ''
    substituteInPlace requirements.txt --replace "argparse" ""
  '';
}

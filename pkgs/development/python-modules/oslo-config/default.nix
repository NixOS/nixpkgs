{ buildPythonPackage, fetchPypi, pbr, six, netaddr, stevedore, mock }:

buildPythonPackage rec {
  pname = "oslo.config";
  version = "2.5.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "043mavrzj7vjn7kh1dddci4sf67qwqnnn6cm0k1d19alks9hismz";
  };

  propagatedBuildInputs = [ pbr six netaddr stevedore ];
  buildInputs = [ mock ];

  # TODO: circular import on oslo-i18n
  doCheck = false;

  postPatch = ''
    substituteInPlace requirements.txt --replace "argparse" ""
  '';
}

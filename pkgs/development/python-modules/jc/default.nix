{ stdenv
, buildPythonPackage
, fetchPypi,
  ruamel_yaml
, ifconfig-parser
, xmltodict
, isPy27
}:

buildPythonPackage rec {
  pname = "jc";
  version = "1.9.2";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1zn6skiv5nm7g8cs86n152ni79ck538bwdjynlh8n2k9dvfd5i8l";
  };

  propagatedBuildInputs = [ ruamel_yaml ifconfig-parser xmltodict ];

  meta = with stdenv.lib; {
    description = "This tool serializes the output of popular command line tools and filetypes to structured JSON output.";
    homepage = "https://github.com/kellyjonbrazil/jc";
    license = licenses.mit;
    maintainers = with maintainers; [ atemu ];
  };
}

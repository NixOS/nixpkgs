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
  version = "1.7.5";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "16ndzvyvx4s3b6cnhxbd5fs3fkc3fwygz7qzaw7ws76sag1zpx67";
  };

  propagatedBuildInputs = [ ruamel_yaml ifconfig-parser xmltodict ];

  meta = with stdenv.lib; {
    description = "This tool serializes the output of popular command line tools and filetypes to structured JSON output.";
    homepage = "https://github.com/kellyjonbrazil/jc";
    license = licenses.mit;
    maintainers = with maintainers; [ atemu ];
  };
}

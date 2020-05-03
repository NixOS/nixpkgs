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
  version = "1.9.3";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1hg6h3ag4pbilpmqylnj7dflz7avk3w8ngmk6psfqrizizwx0hnj";
  };

  propagatedBuildInputs = [ ruamel_yaml ifconfig-parser xmltodict ];

  meta = with stdenv.lib; {
    description = "This tool serializes the output of popular command line tools and filetypes to structured JSON output.";
    homepage = "https://github.com/kellyjonbrazil/jc";
    license = licenses.mit;
    maintainers = with maintainers; [ atemu ];
  };
}

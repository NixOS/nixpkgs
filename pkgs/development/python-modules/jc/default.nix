{ stdenv
, buildPythonPackage
, fetchPypi
, ruamel_yaml
, xmltodict
, pygments
, isPy27
}:

buildPythonPackage rec {
  pname = "jc";
  version = "1.10.7";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "198vsnh6j0nv9d7msnvw6qr1bzf0nffjsz7clm11bs7fh3ri3qxp";
  };

  propagatedBuildInputs = [ ruamel_yaml xmltodict pygments ];

  meta = with stdenv.lib; {
    description = "This tool serializes the output of popular command line tools and filetypes to structured JSON output.";
    homepage = "https://github.com/kellyjonbrazil/jc";
    license = licenses.mit;
    maintainers = with maintainers; [ atemu ];
  };
}

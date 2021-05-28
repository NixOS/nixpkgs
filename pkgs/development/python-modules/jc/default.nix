{ stdenv
, buildPythonPackage
, fetchFromGitHub
, ruamel_yaml
, xmltodict
, pygments
, isPy27
}:

buildPythonPackage rec {
  pname = "jc";
  version = "1.13.4";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "kellyjonbrazil";
    repo = "jc";
    rev = "v${version}";
    sha256 = "0rwvyyrdnw43pixp8h51rncq2inc9pbbj1j2191y5si00pjw34zr";
  };

  propagatedBuildInputs = [ ruamel_yaml xmltodict pygments ];

  meta = with stdenv.lib; {
    description = "This tool serializes the output of popular command line tools and filetypes to structured JSON output.";
    homepage = "https://github.com/kellyjonbrazil/jc";
    license = licenses.mit;
    maintainers = with maintainers; [ atemu ];
  };
}

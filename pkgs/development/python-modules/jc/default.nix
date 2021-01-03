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
  version = "1.14.0";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "kellyjonbrazil";
    repo = "jc";
    rev = "v${version}";
    sha256 = "0js3mqp6xxg45qsz8wnyyqf4m0wj1kz67bkmvirhdy7s01zhd5hq";
  };

  propagatedBuildInputs = [ ruamel_yaml xmltodict pygments ];

  meta = with stdenv.lib; {
    description = "This tool serializes the output of popular command line tools and filetypes to structured JSON output";
    homepage = "https://github.com/kellyjonbrazil/jc";
    license = licenses.mit;
    maintainers = with maintainers; [ atemu ];
  };
}

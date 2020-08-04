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
  version = "1.13.1";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "kellyjonbrazil";
    repo = "jc";
    rev = "v${version}";
    sha256 = "1q5s81izfvxlifa0kzj2qih03d4d0gf7jxkilrcv40rsag5jfb16";
  };

  propagatedBuildInputs = [ ruamel_yaml xmltodict pygments ];

  meta = with stdenv.lib; {
    description = "This tool serializes the output of popular command line tools and filetypes to structured JSON output.";
    homepage = "https://github.com/kellyjonbrazil/jc";
    license = licenses.mit;
    maintainers = with maintainers; [ atemu ];
  };
}

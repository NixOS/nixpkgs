{ stdenv, fetchFromGitHub, buildPythonPackage, pytest }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "iso3166";
  version = "0.8";

  src = fetchFromGitHub {
    owner = "deactivated";
    repo = "python-iso3166";
    # repo has no version tags
    rev = "f04e499447bbff10af701cf3dd81f6bcdf02f7d7";
    sha256 = "0zs9za9dr2nl5srxir08yibmp6nffcapmzala0fgh8ny7y6rafrx";
  };

  buildInputs = [ pytest ];

  checkPhase = ''
    py.test
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/deactivated/python-iso3166;
    description = "Self-contained ISO 3166-1 country definitions";
    license = licenses.mit;
    maintainers = with maintainers; [ zraexy ];
  };
}

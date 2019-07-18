{ lib
, buildPythonPackage
, fetchFromGitHub
, marshmallow
, pytest
, isPy27
, enum34
, pytest-flake8
}:

buildPythonPackage rec {
  pname = "marshmallow-enum";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "justanr";
    repo = "marshmallow_enum";
    rev = "v${version}";
    sha256 = "0ll65y8p0np6ayy8h8g5psf9xm7s0nclarxsh21fdsm72zscx356";
  };

  propagatedBuildInputs = [
    marshmallow
  ] ++ lib.optionals isPy27 [ enum34 ];

  checkInputs = [
    pytest
    pytest-flake8
  ];

  checkPhase = ''
    pytest tests
  '';

  meta = with lib; {
    description = "Enum field for Marshmallow";
    homepage = https://github.com/justanr/marshmallow_enum;
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}

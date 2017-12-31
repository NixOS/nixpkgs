{ lib
, buildPythonPackage
, fetchFromGitHub
, decorator
, appdirs
, six
, numpy
, pytest
}:

buildPythonPackage rec {
  pname = "pytools";
  version = "2017.4";

  src = fetchFromGitHub {
    owner = "inducer";
    repo = "pytools";
    rev = "8078e74265bb5a3c9676c698595ab5450cd2bfe7";
    sha256 = "17q61l79fcxkj5jxg3fnymi652sdjp5s6kpsabgxp22kma9crr28";
  };

  checkInputs = [ pytest ];

  propagatedBuildInputs = [
    decorator
    appdirs
    six
    numpy
  ];

  checkPhase = ''
    py.test -k 'not test_persistent_dict'
  '';

  meta = {
    homepage = https://github.com/inducer/pytools/;
    description = "Miscellaneous Python lifesavers.";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ artuuge ];
  };
}
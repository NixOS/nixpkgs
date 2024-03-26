{ lib
, buildPythonPackage
, fetchFromGitHub
, pytest
}:

buildPythonPackage rec {
  version = "2.0.1";
  format = "setuptools";
  pname = "path-and-address";

  src = fetchFromGitHub {
    owner = "joeyespo";
    repo = "path-and-address";
    rev = "v${version}";
    sha256 = "0b0afpsaim06mv3lhbpm8fmawcraggc11jhzr6h72kdj1cqjk5h6";
  };

  nativeCheckInputs = [ pytest ];

  checkPhase = ''
    py.test
  '';

  meta = with lib; {
    description = "Functions for server CLI applications used by humans";
    homepage = "https://github.com/joeyespo/path-and-address";
    license = licenses.mit;
    maintainers = with maintainers; [ koral];
  };

}

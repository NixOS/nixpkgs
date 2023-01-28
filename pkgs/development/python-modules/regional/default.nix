{ lib
, buildPythonPackage
, fetchFromGitHub
, numpy
, scipy
, matplotlib
, pytest
}:

buildPythonPackage rec {
  pname = "regional";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "freeman-lab";
    repo = pname;
    rev = "e3a29c58982e5cd3d5700131ac96e5e0b84fb981"; # no tags in repo
    sha256 = "03qgm35q9sa5cy0kkw4bj60zfylw0isfzb96nlhdfrsigzs2zkxv";
  };

  propagatedBuildInputs = [
    numpy
    scipy
    matplotlib
  ];

  nativeCheckInputs = [
    pytest
  ];

  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    description = "Simple manipualtion and display of spatial regions";
    homepage = "https://github.com/freeman-lab/regional";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}

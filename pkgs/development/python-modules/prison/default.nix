{ lib
, buildPythonPackage
, fetchFromGitHub
, six
, nose
}:

buildPythonPackage rec {
  pname = "prison";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "betodealmeida";
    repo = "python-rison";
    # The repo doens't have proper tags, commit b77e5bc7cb1a198f2cbf0366bf9acc10b8e67dd5 has version 0.2.1
    rev = "b77e5bc7cb1a198f2cbf0366bf9acc10b8e67dd5";
    sha256 = "sha256-aCQ2254appVBsKuJgSeraWWyh1d9rt8KDt/f8afpVwo=";
  };

  propagatedBuildInputs = [
    six
  ];

  checkInputs = [
    nose
  ];

  meta = with lib; {
    description = "Rison encoder/decoder";
    homepage = "https://github.com/betodealmeida/python-rison";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}

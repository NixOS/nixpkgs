{ lib
, buildPythonPackage
, fetchFromGitHub
, six
, nose
}:

buildPythonPackage rec {
  pname = "prison";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "betodealmeida";
    repo = "python-rison";
    rev = version;
    sha256 = "sha256-qor40vUQeTdlO3vwug3GGNX5vkNaF0H7EWlRdsY4bvc=";
  };

  propagatedBuildInputs = [
    six
  ];

  nativeCheckInputs = [
    nose
  ];

  meta = with lib; {
    description = "Rison encoder/decoder";
    homepage = "https://github.com/betodealmeida/python-rison";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}

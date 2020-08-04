{ lib, fetchFromGitHub, buildPythonPackage, isPy27, requests }:

buildPythonPackage rec {
  pname = "bravia-tv";
  version = "1.0.6";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "dcnielsen90";
    repo = "python-bravia-tv";
    rev = "v${version}";
    sha256 = "07i1j3y04w2jwylff8w1aimmy4fj1g42wq8iz83an7dl4cz3rap9";
  };

  propagatedBuildInputs = [ requests ];

  # package does not include tests
  doCheck = false;

  pythonImportsCheck = [ "bravia_tv" ];

  meta = with lib; {
    homepage = "https://github.com/dcnielsen90/python-bravia-tv";
    description = "Python library for Sony Bravia TV remote control";
    license = licenses.mit;
    maintainers = with maintainers; [ colemickens ];
  };
}

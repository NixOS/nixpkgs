{ lib, fetchFromGitHub, buildPythonPackage, isPy27, requests }:

buildPythonPackage rec {
  pname = "bravia-tv";
  version = "1.0.5";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "dcnielsen90";
    repo = "python-bravia-tv";
    rev = "v${version}";
    sha256 = "17nd0v3pgmbfafi3vypls9jnpg4dk7wyh7fl7gpzcnkq1f8pf087";
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

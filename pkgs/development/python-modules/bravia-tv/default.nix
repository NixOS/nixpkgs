{ lib, fetchFromGitHub, buildPythonPackage, isPy27, requests }:

buildPythonPackage rec {
  pname = "bravia-tv";
  version = "1.0.7";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "dcnielsen90";
    repo = "python-bravia-tv";
    rev = "v${version}";
    sha256 = "0bg33nilybh46s6yz3x7a7x8biwbvy5scqdrl4didhn7vjd4w5fn";
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

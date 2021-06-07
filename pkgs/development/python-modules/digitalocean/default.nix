{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchPypi
, isPy3k
, jsonpickle
, mock
, pytest
, pytestCheckHook
, requests
, responses
}:

buildPythonPackage rec {
  pname = "python-digitalocean";
  version = "1.16.0";

  src = fetchFromGitHub {
    owner = "koalalorenzo";
    repo = pname;
    rev = "v${version}";
    sha256 = "16fxlfpisj4rcj9dvlifs6bpx42a0sn9b07bnyzwrbhi6nfvkd2g";
  };

  propagatedBuildInputs = [
    jsonpickle
    requests
  ];

  dontUseSetuptoolsCheck = true;

  checkInputs = [
    pytest
    pytestCheckHook
    responses
  ] ++ lib.optionals (!isPy3k) [
    mock
  ];

  preCheck = ''
    cd digitalocean
  '';

  pythonImportsCheck = [ "digitalocean" ];

  meta = with lib; {
    description = "Python API to manage Digital Ocean Droplets and Images";
    homepage = "https://github.com/koalalorenzo/python-digitalocean";
    license = with licenses; [ lgpl3Only ];
    maintainers = with maintainers; [ kiwi teh ];
  };
}

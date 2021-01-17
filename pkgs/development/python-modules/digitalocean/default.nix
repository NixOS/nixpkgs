{ buildPythonPackage
, fetchFromGitHub
, fetchPypi
, isPy3k
, jsonpickle
, mock
, pytest
, pytestCheckHook
, requests
, responses
, lib, stdenv
}:

buildPythonPackage rec {
  pname = "python-digitalocean";
  version = "1.16.0";

  src = fetchFromGitHub {
    owner = "koalalorenzo";
    repo = "python-digitalocean";
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
  ] ++ stdenv.lib.optionals (!isPy3k) [
    mock
  ];

  preCheck = ''
    cd digitalocean
  '';

  meta = with lib; {
    description = "digitalocean.com API to manage Droplets and Images";
    homepage = "https://pypi.python.org/pypi/python-digitalocean";
    license = licenses.lgpl3;
    maintainers = with maintainers; [
      kiwi
      teh
    ];
  };
}

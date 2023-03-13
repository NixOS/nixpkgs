{ lib
, buildPythonPackage
, fetchFromGitHub
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
  version = "1.17.0";

  src = fetchFromGitHub {
    owner = "koalalorenzo";
    repo = pname;
    rev = "v${version}";
    sha256 = "1c50ka4y712rr551gq3kdfw7fgfxr4w837sww6yy683yz7m1d1h8";
  };

  propagatedBuildInputs = [
    jsonpickle
    requests
  ];

  dontUseSetuptoolsCheck = true;

  nativeCheckInputs = [
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

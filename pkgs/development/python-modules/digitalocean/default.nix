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
, stdenv
}:

buildPythonPackage rec {
  pname = "python-digitalocean";
  version = "1.15.0";

  src = fetchFromGitHub {
    owner = "koalalorenzo";
    repo = "python-digitalocean";
    rev = "v${version}";
    sha256 = "1pz15mh72i992p63grwzqn2bbp6sm37zcp4f0fy1z7rsargwsbcz";
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

  meta = with stdenv.lib; {
    description = "digitalocean.com API to manage Droplets and Images";
    homepage = "https://pypi.python.org/pypi/python-digitalocean";
    license = licenses.lgpl3;
    maintainers = with maintainers; [
      kiwi
      teh
    ];
  };
}

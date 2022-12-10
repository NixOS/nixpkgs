{ lib
, buildPythonPackage
, fetchFromGitHub
, isPy27
, pytest-runner
, requests
}:

buildPythonPackage rec {
  pname = "pyosf";
  version = "1.0.5";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "psychopy";
    repo = pname;
    rev = "v${version}";
    sha256 = "1fkpmylpcbqa9ky111mz4qr1n8pik49gs7pblbb5qx6b54fzl5k2";
  };

  preBuild = "export HOME=$TMP";
  buildInputs = [ pytest-runner ];  # required via `setup_requires`
  propagatedBuildInputs = [ requests ];

  doCheck = false;  # requires network access
  pythonImportsCheck = [ "pyosf" ];

  meta = with lib; {
    homepage = "https://github.com/psychopy/pyosf";
    description = "Pure Python library for simple sync with Open Science Framework";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}

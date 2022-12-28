{ lib
, buildPythonPackage
, fetchFromGitHub
, isPy3k
, prompt-toolkit }:

buildPythonPackage rec {
  pname = "clintermission";
  version = "0.2.0";
  format = "setuptools";

  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "sebageek";
    repo = pname;
    rev = "v${version}";
    sha256 = "09wl0rpw6c9hab51rs957z64b0v9j4fcbqbn726wnapf4z5w6yxv";
  };

  propagatedBuildInputs = [
    prompt-toolkit
  ];

  # repo contains no tests
  doCheck = false;

  pythonImportsCheck = [
    "clintermission"
  ];

  meta = with lib; {
    description = "Non-fullscreen command-line selection menu";
    homepage = "https://github.com/sebageek/clintermission";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}

{ lib
, buildPythonPackage
, fetchFromGitHub
, isPy3k
, prompt-toolkit }:

buildPythonPackage rec {
  pname = "clintermission";
  version = "0.3.0";
  format = "setuptools";

  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "sebageek";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-HPeO9K91a0MacSUN0SR0lPEWRTQgP/cF1FZaNvZLxAg=";
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

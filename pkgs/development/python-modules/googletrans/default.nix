{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  requests,
}:

buildPythonPackage rec {
  pname = "googletrans";
  version = "4.0.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "ssut";
    repo = "py-googletrans";
    tag = "v${version}";
    sha256 = "sha256-R6LJLHHitJL8maXBCZyx2W47uJh0ZctVDA9oRIEhG5U=";
  };

  propagatedBuildInputs = [ requests ];

  # majority of tests just try to ping Google's Translate API endpoint
  doCheck = false;

  pythonImportsCheck = [ "googletrans" ];

  meta = with lib; {
    description = "Googletrans is python library to interact with Google Translate API";
    mainProgram = "translate";
    homepage = "https://py-googletrans.readthedocs.io";
    license = licenses.mit;
    maintainers = with maintainers; [ unode ];
  };
}

{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "bangla";
  version = "0.0.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-F8j9UBMhZgB31atqebdGu6cfnkk573isDZp1171xXag=";
  };

  pythonImportsCheck = [ "bangla" ];

  # https://github.com/arsho/bangla/issues/5
  doCheck = false;

  meta = with lib; {
    description = "Bangla is a package for Bangla language users with various functionalities including Bangla date and Bangla numeric conversation";
    homepage = "https://github.com/arsho/bangla";
    license = licenses.mit;
    maintainers = teams.tts.members;
  };
}

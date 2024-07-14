{
  lib,
  buildPythonPackage,
  fetchPypi,
  six,
}:

buildPythonPackage rec {
  pname = "dockerpty";
  version = "0.4.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-aanWnVc6DaoxvNHAd07u1cFcKV/nGcYaylUO0TkxVs4=";
  };

  propagatedBuildInputs = [ six ];

  meta = with lib; {
    description = "Functionality needed to operate the pseudo-tty (PTY) allocated to a docker container";
    homepage = "https://github.com/d11wtq/dockerpty";
    license = licenses.asl20;
  };
}

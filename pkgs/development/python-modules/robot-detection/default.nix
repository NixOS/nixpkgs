{
  lib,
  buildPythonPackage,
  fetchPypi,
  six,
}:

buildPythonPackage rec {
  pname = "robot-detection";
  version = "0.4";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1xd2jm3yn31bnk1kqzggils2rxj26ylxsfz3ap7bhr3ilhnbg3rx";
  };

  propagatedBuildInputs = [ six ];

  # no tests in archive
  doCheck = false;

  meta = {
    description = "Library for detecting if a HTTP User Agent header is likely to be a bot";
    homepage = "https://github.com/rory/robot-detection";
    license = lib.licenses.gpl3Plus;
  };
}

{ lib
, buildPythonPackage
, fetchPypi
, requests
, pytest
, mock
, sphinx
}:

buildPythonPackage rec {
  pname = "readthedocs-sphinx-ext";
  version = "2.1.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-G/QuIOW3qUOJGnmM5cy5H9W6wiMLDBmdhTgMkhAHa3g=";
  };

  propagatedBuildInputs = [ requests ];

  checkInputs = [ pytest mock sphinx ];

  checkPhase = ''
    py.test
  '';

  meta = with lib; {
    description = "Sphinx extension for Read the Docs overrides";
    homepage = "https://github.com/rtfd/readthedocs-sphinx-ext";
    license = licenses.mit;
  };
}

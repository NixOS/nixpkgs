{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "python-oauth2";
  version = "1.1.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-16hUSSesGCFbpTF+3Y9kCl8fBZOSG8886GIXgxLIyaQ=";
  };
  # attempts to run mysql
  doCheck = false;

  meta = with lib; {
    description = "Framework that aims at making it easy to provide authentication via OAuth 2.0 within an application stack";
    homepage = "https://github.com/wndhydrnt/python-oauth2";
    license = licenses.mit;
  };
}

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
    sha256 = "d7a8544927ac18215ba5317edd8f640a5f1f0593921bcf3ce862178312c8c9a4";
  };
  # attempts to run mysql
  doCheck = false;

  meta = with lib; {
    description = "Framework that aims at making it easy to provide authentication via OAuth 2.0 within an application stack";
    homepage = "https://github.com/wndhydrnt/python-oauth2";
    license = licenses.mit;
  };
}

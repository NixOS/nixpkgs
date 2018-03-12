{ lib
, python
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "python-oauth2";
  version = "1.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0a1d0qnlgm07wq9r9bbm5jqkqry73w34m87p0141bk76lg7bb0sm";
  };
  # attempts to run mysql
  doCheck = false;

  meta = with lib; {
    description = "Framework that aims at making it easy to provide authentication via OAuth 2.0 within an application stack";
    homepage =  https://github.com/wndhydrnt/python-oauth2;
    license = licenses.mit;
    maintainers = with maintainers; [ ixxie ];
  };
}

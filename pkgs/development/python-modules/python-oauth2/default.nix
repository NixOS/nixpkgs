{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "python-oauth2";
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b24da812837c19183df1924e80a22ba0a1869582dea8b04a9ecd807b04dbc525";
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

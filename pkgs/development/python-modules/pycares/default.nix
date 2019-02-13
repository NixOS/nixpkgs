{ stdenv
, buildPythonPackage
, fetchPypi
, pkgs
}:

buildPythonPackage rec {
  pname = "pycares";
  version = "2.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "15pwsxsj1nr33n6x2918bfbzdnqv1qkwd2d5jgvxsm81zxnvgk0f";
  };

  propagatedBuildInputs = [ pkgs.c-ares ];

  # No tests included
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/saghul/pycares;
    description = "Interface for c-ares";
    license = licenses.mit;
  };

}

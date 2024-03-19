{ stdenv
, lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "LTpycld2";
  version = "0.42";

  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "948d0c1ab5518ab4efcbcc3cd73bb29f809f1dfb30f4d2fbd81b175a1ffeb516";
  };

  doCheck = false; # completely broken tests

  pythonImportsCheck = [ "pycld2" ];

  meta = with lib; {
    description = "Python bindings around Google Chromium's embedded compact language detection library (CLD2)";
    homepage = "https://github.com/LibreTranslate/pycld2";
    license = licenses.asl20;
    maintainers = with maintainers; [ misuzu ];
    broken = stdenv.isDarwin;
  };
}

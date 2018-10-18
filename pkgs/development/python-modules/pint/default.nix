{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "pint";
  version = "0.7.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1bbp5s34gcb9il2wyz4spznshahwbjvwi5bhjm7bnxk358spvf9q";
  };

  meta = with stdenv.lib; {
    description = "Physical quantities module";
    license = licenses.bsd3;
    homepage = "https://github.com/hgrecco/pint/";
  };

}

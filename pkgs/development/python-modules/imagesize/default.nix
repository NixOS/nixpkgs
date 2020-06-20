{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "imagesize";
  version = "1.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b1f6b5a4eab1f73479a50fb79fcf729514a900c341d8503d62a62dbc4127a2b1";
  };

  meta = with stdenv.lib; {
    description = "Getting image size from png/jpeg/jpeg2000/gif file";
    homepage = "https://github.com/shibukawa/imagesize_py";
    license = with licenses; [ mit ];
  };

}

{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "html2text";
  version = "2016.9.19";

  src = fetchPypi {
    inherit pname version;
    sha256 = "554ef5fd6c6cf6e3e4f725a62a3e9ec86a0e4d33cd0928136d1c79dbeb7b2d55";
  };

  meta = with stdenv.lib; {
    description = "Turn HTML into equivalent Markdown-structured text";
    homepage = https://github.com/Alir3z4/html2text/;
    license = licenses.gpl3;
  };

}

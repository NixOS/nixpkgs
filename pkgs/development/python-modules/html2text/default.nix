{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "html2text";
  version = "2018.1.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "627514fb30e7566b37be6900df26c2c78a030cc9e6211bda604d8181233bcdd4";
  };

  meta = with stdenv.lib; {
    description = "Turn HTML into equivalent Markdown-structured text";
    homepage = https://github.com/Alir3z4/html2text/;
    license = licenses.gpl3;
  };

}

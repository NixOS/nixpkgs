{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "html2text";
  version = "2019.9.26";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6f56057c5c2993b5cc5b347cb099bdf6d095828fef1b53ef4e2a2bf2a1be9b4f";
  };

  meta = with stdenv.lib; {
    description = "Turn HTML into equivalent Markdown-structured text";
    homepage = https://github.com/Alir3z4/html2text/;
    license = licenses.gpl3;
  };

}

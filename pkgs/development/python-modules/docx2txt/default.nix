{ buildPythonPackage, fetchPypi, lib }:

buildPythonPackage rec {
  pname = "docx2txt";
  version = "0.7";
  src = fetchPypi {
    inherit pname version;
    sha256 = "03vzd774nhlnq4i41vqx647w19dr6989zrps70ldwzc2xgjn6lrk";
  };

  meta = with lib; {
    description = "A pure python based utility to extract text and images from docx files";
    license = licenses.mit;
    homepage = https://github.com/ankushshah89/python-docx2txt;
    maintainers = with maintainers; [ mredaelli ];
  };
}

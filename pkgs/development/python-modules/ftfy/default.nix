{ stdenv
, buildPythonPackage
, fetchPypi
, html5lib
, wcwidth
, nose
, python
}:
buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "ftfy";
  version = "4.4.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "152xdb56rhs1q4r0ck1n557sbphw7zq18r75a7kkd159ckdnc01w";        
  };

  propagatedBuildInputs = [ html5lib wcwidth];

  buildInputs = [
    nose
  ];

  checkPhase = ''
    nosetests -v
  '';

  meta = with stdenv.lib; {
    description = "Given Unicode text, make its representation consistent and possibly less broken.";
    homepage = https://github.com/LuminosoInsight/python-ftfy/tree/master/tests;
    license = licenses.mit;
    maintainers = with maintainers; [ sdll ];    
    };
}

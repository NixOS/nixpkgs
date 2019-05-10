{ stdenv
, buildPythonPackage
, fetchPypi
, pytest
, pbr
, pyenchant
, polib
}:

buildPythonPackage rec {
  pname = "pytest-translations";
  version = "2.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "025wh3rqlv82w7j5632wng6524np9w4a4vj803jcbk26hzlsanlg";
  };

  buildInputs = [
    pytest
    pbr
    pyenchant
    polib
  ];

  meta = with stdenv.lib; {
    license = licenses.asl20;
    homepage = https://github.com/Thermondo/pytest-translations;
    description = "Tests translation files with pytest";
  };
}

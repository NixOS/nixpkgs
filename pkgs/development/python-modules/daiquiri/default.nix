{ stdenv
, buildPythonPackage
, fetchPypi
, pbr
, pytest
, python-json-logger
}:

buildPythonPackage rec {
  version = "1.5.0";
  pname = "daiquiri";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8832f28e110165b905993b4bdab638a3c245f5671d5976f226f2628e7d2e7862";
  };

  checkInputs = [ pytest ];
  propagatedBuildInputs = [ pbr python-json-logger ];

  checkPhase = ''
    py.test daiquiri
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/jd/daiquiri;
    description = "Library to configure Python logging easily";
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}

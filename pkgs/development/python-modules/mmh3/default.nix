{ lib
, fetchPypi
, buildPythonPackage
}:

buildPythonPackage rec {
  pname = "mmh3";
  version = "2.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0265pvfbcsijf51szsh14qk3l3zgs0rb5rbrw11zwan52yi0jlhq";
  };

  pythonImportsCheck = [ "mmh3" ];

  meta = with lib; {
    description = "Python wrapper for MurmurHash3, a set of fast and robust hash functions";
    homepage = "https://pypi.org/project/mmh3/";
    license = licenses.cc0;
    maintainers = [ maintainers.danieldk ];
  };
}

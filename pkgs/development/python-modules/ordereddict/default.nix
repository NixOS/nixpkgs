{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "ordereddict";
  version = "1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "07qvy11nvgxpzarrni3wrww3vpc9yafgi2bch4j2vvvc42nb8d8w";
  };

  meta = with lib; {
    description = "A drop-in substitute for Py2.7's new collections.OrderedDict that works in Python 2.4-2.6";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };

}

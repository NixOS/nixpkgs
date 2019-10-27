{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  version = "0.8.3";
  pname = "bitarray";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0pl9p4j3dhlyffsqra6h28q7jph6v3hgppg786lkmnqdh45x6305";
  };

  # Delete once https://github.com/ilanschnell/bitarray/pull/55 is merged
  patches = [ ./0001-Buffer-Protocol-Py3.patch ];

  meta = with lib; {
    description = "Efficient arrays of booleans";
    homepage = https://github.com/ilanschnell/bitarray;
    license = licenses.psfl;
    maintainers = [ maintainers.bhipple ];
  };
}

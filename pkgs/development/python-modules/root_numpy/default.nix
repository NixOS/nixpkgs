{ lib, fetchPypi, isPy3k, buildPythonPackage, numpy, root }:

buildPythonPackage rec {
  pname = "root_numpy";
  version = "4.7.3";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0vy6mqmkddfv46yc4hp43fvaisn3yw92ryaw031k841hhj73q0xg";
  };

  disabled = isPy3k; # blocked by #27649

  propagatedBuildInputs = [ numpy root ];

  meta = with lib; {
    homepage = http://scikit-hep.org/root_numpy;
    license = licenses.bsd3;
    description = "The interface between ROOT and NumPy";
    maintainers = with maintainers; [ veprbl ];
  };
}

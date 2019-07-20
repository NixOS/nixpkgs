{ lib, fetchPypi, isPy3k, buildPythonPackage, numpy, root, nose }:

buildPythonPackage rec {
  pname = "root_numpy";
  version = "4.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5842bbcde92133f60a61f56e9f0a875a0dbc2a567cc65a9ac141ecd72e416878";
  };

  disabled = isPy3k; # blocked by #27649
  checkInputs = [ nose ];
  checkPhase = ''
    python setup.py install_lib -d .
    nosetests -s -v root_numpy
  '';

  propagatedBuildInputs = [ numpy root ];

  meta = with lib; {
    homepage = http://scikit-hep.org/root_numpy;
    license = licenses.bsd3;
    description = "The interface between ROOT and NumPy";
    maintainers = with maintainers; [ veprbl ];
  };
}

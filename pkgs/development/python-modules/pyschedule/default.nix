{ lib
, buildPythonPackage
, fetchPypi
, pulp
}:

buildPythonPackage rec {
  pname = "pyschedule";
  version = "0.2.17";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0mlcmz1cm9yixlvh1d1c6c91j48hhcmbxf8cacqqh7dmgi7pmrs9";
  };

  propagatedBuildInputs = [ pulp ];

  meta = with lib; {
    homepage    = https://github.com/timnon/pyschedule;
    description = "resource-constrained scheduling in python";
    license     = licenses.asl20;
    maintainers = with maintainers; [ ericsagnes ];
  };
}

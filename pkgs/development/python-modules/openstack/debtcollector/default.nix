{ lib, buildPythonApplication, fetchPypi
, pbr, six, wrapt
}:

buildPythonApplication rec {
  pname = "openstack-debtcollector";
  version = "2.2.0";

  src = fetchPypi {
    pname = "debtcollector";
    inherit version;
    sha256 = "787981f4d235841bf6eb0467e23057fb1ac7ee24047c32028a8498b9128b6829";
  };

  propagatedBuildInputs = [
    pbr
    six
    wrapt
  ];

  doCheck = false;

  pythonImportsCheck = [ "debtcollector" ];

  meta = with lib; {
    description = "A collection of Python deprecation patterns and strategies that help you collect your technical debt in a non-destructive manner";
    downloadPage = "https://pypi.org/project/debtcollector/";
    homepage = "https://github.com/openstack/debtcollector";
    license = licenses.asl20;
    maintainers = with maintainers; [ superherointj ];
  };
}

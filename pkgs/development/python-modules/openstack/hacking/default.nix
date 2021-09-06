{ lib, buildPythonPackage, fetchPypi
, flake8, pbr
}:

buildPythonPackage rec {
  pname = "hacking";
  version = "4.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "150839891be9e13f784b5f809091fb9e8c72aef43d9898830f76f8c9684ee139";
  };

  patchPhase = ''
    echo "flake8" > requirements.txt
  '';

  propagatedBuildInputs = [
    flake8
    pbr
  ];

  doCheck = false;

  pythonImportsCheck = [ "hacking" ];

  meta = with lib; {
    description = "A set of flake8 plugins that test and enforce the OpenStack StyleGuide";
    downloadPage = "https://pypi.org/project/hacking/";
    homepage = "https://docs.openstack.org/hacking/";
    license = licenses.asl20;
    maintainers = with maintainers; [ superherointj ];
  };
}

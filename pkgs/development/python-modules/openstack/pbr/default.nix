{ lib, buildPythonPackage, fetchPypi
, setuptools
}:

buildPythonPackage rec {
  pname = "openstack-pbr";
  version = "5.6.0";

  src = fetchPypi {
    pname = "pbr";
    inherit version;
    sha256 = "42df03e7797b796625b1029c0400279c7c34fd7df24a7d7818a1abb5b38710dd";
  };

  propagatedBuildInputs = [
    setuptools
  ];

  checkPhase = ''
    runHook preCheck
    $out/bin/pbr --version | grep ${version} > /dev/null
    runHook postCheck
  '';

  pythonImportsCheck = [ "pbr" ];

  meta = with lib; {
    description = "Python Build Reasonableness";
    downloadPage = "https://github.com/openstack/pbr";
    homepage = "http://docs.openstack.org/developer/pbr/";
    license = licenses.asl20;
    maintainers = with maintainers; [ superherointj ];
  };
}

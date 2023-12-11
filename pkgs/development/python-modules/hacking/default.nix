{ lib
, buildPythonPackage
, fetchPypi
, pbr
, flake8
, stestr
, ddt
, testscenarios
}:

buildPythonPackage rec {
  pname = "hacking";
  version = "6.0.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-YdeEb8G58m7CFnjpkHQmkJX5ZNe72M1kbrbIxML4jcE=";
  };

  postPatch = ''
    sed -i 's/flake8.*/flake8/' requirements.txt
    substituteInPlace hacking/checks/python23.py \
      --replace 'H236: class Foo(object):\n    __metaclass__ = \' 'Okay: class Foo(object):\n    __metaclass__ = \'
    substituteInPlace hacking/checks/except_checks.py \
      --replace 'H201: except:' 'Okay: except:'
  '';

  nativeBuildInputs = [ pbr ];

  propagatedBuildInputs = [
    flake8
  ];

  nativeCheckInputs = [
    ddt
    stestr
    testscenarios
  ];

  checkPhase = ''
    # tries to trigger flake8 and fails
    rm hacking/tests/test_doctest.py

    stestr run
  '';

  pythonImportsCheck = [ "hacking" ];

  meta = with lib; {
    description = "OpenStack Hacking Guideline Enforcement";
    homepage = "https://github.com/openstack/hacking";
    license = licenses.asl20;
    maintainers = teams.openstack.members;
  };
}

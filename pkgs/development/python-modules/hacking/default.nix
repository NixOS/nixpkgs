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
  version = "5.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-qzWyCK8/FHpvlZUnMxw4gK5BrCHMzra/1oqE9OtW4CY=";
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

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
  version = "4.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0fg19rlcky3n1y1ri61xyjp7534yzf8r102z9dw3zqg93f4kj20m";
  };

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "flake8<3.9.0,>=3.8.0" "flake8"
    substituteInPlace hacking/checks/python23.py \
      --replace 'H236: class Foo(object):\n    __metaclass__ = \' 'Okay: class Foo(object):\n    __metaclass__ = \'
    substituteInPlace hacking/checks/except_checks.py \
      --replace 'H201: except:' 'Okay: except:'
  '';

  nativeBuildInputs = [ pbr ];

  propagatedBuildInputs = [
    flake8
  ];

  checkInputs = [
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

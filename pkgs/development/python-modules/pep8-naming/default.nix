{ lib
, fetchPypi
, fetchpatch
, buildPythonPackage
, flake8
, flake8-polyfill
, python
}:

buildPythonPackage rec {
  pname = "pep8-naming";
  version = "0.11.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0937rnk3c2z1jkdmbw9hfm80p5k467q7rqhn6slfiprs4kflgpd1";
  };

  patches = [
    (fetchpatch {
      # Fix tests by setting extended-default-ignore to an empty list
      url = "https://github.com/PyCQA/pep8-naming/commit/6d62db81d7967e123e29673a4796fefec6f06d26.patch";
      sha256 = "1jpr2dga8sphksik3izyzq9hiszyki691mwnh2rjzd2vpgnv8cxf";
    })
  ];

  propagatedBuildInputs = [
    flake8
    flake8-polyfill
  ];

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} run_tests.py
    runHook postCheck
  '';

  pythonImportsCheck = [
    "pep8ext_naming"
  ];

  meta = with lib; {
    homepage = "https://github.com/PyCQA/pep8-naming";
    description = "Check PEP-8 naming conventions, plugin for flake8";
    license = licenses.mit;
    maintainers = with maintainers; [ eadwu ];
  };
}

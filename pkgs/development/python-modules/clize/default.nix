{ lib
, buildPythonPackage
, fetchFromGitHub
, python-dateutil
, sigtools
, six
, attrs
, od
, docutils
, repeated_test
, pygments
, unittest2
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "clize";
  version = "4.2.1";

  src = fetchFromGitHub {
     owner = "epsy";
     repo = "clize";
     rev = "4.2.1";
     sha256 = "0l68bdmbyjrp8dwz7ww206r8jbmxx2wbwma99rcpyymm2dfikkhr";
  };

  checkInputs = [
    pytestCheckHook
    python-dateutil
    pygments
    repeated_test
    unittest2
  ];

  propagatedBuildInputs = [
    attrs
    docutils
    od
    sigtools
    six
  ];

  pythonImportsCheck = [ "clize" ];

  meta = with lib; {
    description = "Command-line argument parsing for Python";
    homepage = "https://github.com/epsy/clize";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}

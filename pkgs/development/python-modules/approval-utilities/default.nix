{
  lib,
  buildPythonPackage,
  approvaltests,
  pythonOlder,
  setuptools,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "approval-utilities";
  inherit (approvaltests) version src;
  disabled = pythonOlder "3.7";
  pyproject = true;

  postPatch = ''
    mv setup.approval_utilities.py setup.py
  '';

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    # used in approval_utilities/utilities/time_utilities.py
    typing-extensions
  ];

  pythonImportsCheck = [ "approval_utilities" ];

  # upstream has no tests
  doCheck = false;

  meta = {
    description = "Utilities for your production code that work well with approvaltests";
    homepage = "https://github.com/approvals/ApprovalTests.Python";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}

{
  lib,
  buildPythonPackage,
  approvaltests,
  setuptools,
  typing-extensions,
}:

buildPythonPackage {
  pname = "approval-utilities";
  inherit (approvaltests) version src;
  pyproject = true;

  postPatch = approvaltests.postPatch or "" + ''
    mv setup.approval_utilities.py setup.py
  '';

  build-system = [ setuptools ];

  dependencies = [
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

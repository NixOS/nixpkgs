{ lib, fetchgit, buildPythonPackage, colcon-core }:

buildPythonPackage rec {
  pname = "colcon-test-result";
  version = "0.3.8";
  src = fetchgit {
    url = "https://github.com/colcon/colcon-test-result.git";
    rev = "refs/tags/${version}";
    deepClone = true;
    sha256 = "PJ6I+kMcJJcgOd3ILLLfZit8dPoOebYtha5lcvQDt8o=";
  };

  propagatedBuildInputs = [ colcon-core ];

  # Tests are disabled because the only
  # tests are flake8 and spellcheck, which aren't functional tests
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/colcon/colcon-test-result";
    description = "An extension for colcon-core to provide information about the test results.";
    maintainers = with maintainers; [ nkalupahana ];
    license = licenses.asl20;
  };
}

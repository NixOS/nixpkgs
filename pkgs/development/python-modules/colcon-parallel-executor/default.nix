{ lib, fetchgit, buildPythonPackage, colcon-core }:

buildPythonPackage rec {
  pname = "colcon-parallel-executor";
  version = "0.2.4";
  src = fetchgit {
    url = "https://github.com/colcon/colcon-parallel-executor.git";
    rev = "refs/tags/${version}";
    deepClone = true;
    sha256 = "Ou0dEAgaHyzVqRxyPAyvIbG8pLqImbCybtLwNgZyTKs=";
  };

  propagatedBuildInputs = [ colcon-core ];

  # Tests are disabled because the only
  # tests are flake8 and spellcheck, which aren't functional tests
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/colcon/colcon-parallel-executor";
    description = "An extension for colcon-core to process packages in parallel.";
    maintainers = with maintainers; [ nkalupahana ];
    license = licenses.asl20;
  };
}

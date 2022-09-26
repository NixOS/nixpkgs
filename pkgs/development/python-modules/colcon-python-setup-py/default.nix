{ lib, fetchgit, buildPythonPackage, colcon-core }:

buildPythonPackage rec {
  pname = "colcon-python-setup-py";
  version = "0.2.7";
  src = fetchgit {
    url = "https://github.com/colcon/colcon-python-setup-py.git";
    rev = "refs/tags/${version}";
    deepClone = true;
    sha256 = "Rhvi5CcEAeZ4q1Iicj0GYNf7mfy4TbOXJiawgVYJ854=";
  };

  propagatedBuildInputs = [ colcon-core ];

  # Tests are disabled because the only
  # tests are flake8 and spellcheck, which aren't functional tests
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/colcon/colcon-python-setup-py";
    description = "An extension for colcon-core to identify packages with a setup.py file.";
    maintainers = with maintainers; [ nkalupahana ];
    license = licenses.asl20;
  };
}

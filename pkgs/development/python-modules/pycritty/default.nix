{ lib, buildPythonPackage, fetchPypi, pythonOlder, pyyaml }:

buildPythonPackage rec {
  pname = "pycritty";
  version = "0.3.5";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1lrmd4a1ps3h9z0pndfjfrd2qa7v3abd6np75fd2q2ffsqv7ar6x";
  };

  postPatch = ''
    # remove custom install
    substituteInPlace setup.py \
      --replace "'install': PostInstallHook," ""
  '';

  propagatedBuildInputs = [ pyyaml ];

  # The package does not include any tests to run
  doCheck = false;

  pythonImportsCheck = [ "pycritty" ];

  meta = with lib; {
    description = "A CLI tool for changing your alacritty configuration on the fly";
    homepage = "https://github.com/antoniosarosi/pycritty";
    license = licenses.mit;
    maintainers = with maintainers; [ jperras ];
  };
}

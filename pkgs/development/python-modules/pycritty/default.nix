{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  pyyaml,
}:

buildPythonPackage rec {
  pname = "pycritty";
  version = "0.4.0";
  format = "setuptools";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Lh2zAEJTyzI8dJTNuyaf7gzhySMpui+CF9qRiubwFhE=";
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
    description = "CLI tool for changing your alacritty configuration on the fly";
    mainProgram = "pycritty";
    homepage = "https://github.com/antoniosarosi/pycritty";
    license = licenses.mit;
    maintainers = with maintainers; [ jperras ];
  };
}

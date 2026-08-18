{
  lib,
  buildPythonPackage,
  fetchPypi,
  pyyaml,
}:

buildPythonPackage rec {
  pname = "pycritty";
  version = "0.4.0";
  format = "setuptools";

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

  meta = {
    description = "CLI tool for changing your alacritty configuration on the fly";
    mainProgram = "pycritty";
    homepage = "https://github.com/antoniosarosi/pycritty";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jperras ];
  };
}

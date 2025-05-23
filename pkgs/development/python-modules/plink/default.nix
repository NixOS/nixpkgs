{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pythonOlder,
  sphinx,
  tkinter,
}:

buildPythonPackage rec {
  pname = "plink";
  version = "2.4.6";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-l1MtpwBUl6IZXgjqQyT3QH2zXng0SrRtHoOkOifHUWo=";
  };

  build-system = [ setuptools ];

  nativeBuildInputs = [ sphinx ];

  propagatedBuildInputs = [ tkinter ];

  doCheck = true;

  pythonImportsCheck = [ "plink" ];

  meta = with lib; {
    description = "A full featured Tk-based knot and link editor";
    homepage = "https://github.com/3-manifolds/PLink";
    license = licenses.gpl2;
    maintainers = with maintainers; [ noiioiu ];
  };
}

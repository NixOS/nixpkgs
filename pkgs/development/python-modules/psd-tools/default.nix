{ lib
, buildPythonPackage
, fetchFromGitHub
, isPy27
, docopt
, pillow
, enum34
, scikitimage
, aggdraw
, pytestCheckHook
, ipython
, cython
}:

buildPythonPackage rec {
  pname = "psd-tools";
  version = "1.9.21";

  src = fetchFromGitHub {
    owner = "psd-tools";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-+nqN7DJHbr7XkfG0oUQkWcxv+krR8DlQndAQCvnBk3s=";
  };

  nativeBuildInputs = [ cython ];

  propagatedBuildInputs = [
    aggdraw
    docopt
    ipython
    pillow
    scikitimage
  ];

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "psd_tools" ];

  meta = with lib; {
    description = "Python package for reading Adobe Photoshop PSD files";
    homepage = "https://github.com/kmike/psd-tools";
    license = licenses.mit;
    maintainers = with maintainers; [ onny ];
  };
}

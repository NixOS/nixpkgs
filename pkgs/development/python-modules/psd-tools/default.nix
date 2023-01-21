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
  version = "1.9.23";

  src = fetchFromGitHub {
    owner = "psd-tools";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-pJUf5rE5QMnfNytU1P0Zbj1iztrK5xrX4CJ/WvIG8mY=";
  };

  nativeBuildInputs = [ cython ];

  propagatedBuildInputs = [
    aggdraw
    docopt
    ipython
    pillow
    scikitimage
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "psd_tools" ];

  meta = with lib; {
    description = "Python package for reading Adobe Photoshop PSD files";
    homepage = "https://github.com/kmike/psd-tools";
    license = licenses.mit;
    maintainers = with maintainers; [ onny ];
  };
}

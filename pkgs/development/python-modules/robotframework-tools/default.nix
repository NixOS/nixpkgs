{
  lib,
  buildPythonPackage,
  fetchPypi,
  robotframework,
  moretools,
  path,
  six,
  zetup,
  modeled,
  pytestCheckHook,
}:

buildPythonPackage rec {
  version = "0.1rc4";
  format = "setuptools";
  pname = "robotframework-tools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-JilvnZUDHuY9WFAwMen1mNafOIETMDo8+4MZJ9WM5ww=";
  };

  nativeBuildInputs = [ zetup ];

  propagatedBuildInputs = [
    robotframework
    moretools
    path
    six
    modeled
  ];

  postPatch = ''
    # Remove upstream's selfmade approach to collect the dependencies
    # https://github.com/userzimmermann/robotframework-tools/issues/1
    substituteInPlace setup.py --replace \
      "setup_requires=SETUP_REQUIRES + (zfg.SETUP_REQUIRES or [])," ""
  '';

  nativeCheckInputs = [ pytestCheckHook ];
  pytestFlagsArray = [ "test" ];
  pythonImportsCheck = [ "robottools" ];

  meta = with lib; {
    description = "Python Tools for Robot Framework and Test Libraries";
    homepage = "https://github.com/userzimmermann/robotframework-tools";
    license = licenses.gpl3Plus;
    maintainers = [ ];
  };
}

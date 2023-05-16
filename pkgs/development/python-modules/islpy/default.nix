{ lib
, buildPythonPackage
, fetchPypi
, isl
, pybind11
, pytestCheckHook
, pythonOlder
, six
}:

buildPythonPackage rec {
  pname = "islpy";
<<<<<<< HEAD
  version = "2023.1.2";
=======
  version = "2023.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    sha256 = "sha256-NsNI1N9ZuNYWr1i3dl7hSaTP3jdsTYsIpoF98vrZG9Y=";
=======
    sha256 = "sha256-QLkpCBF95OBOzPrBXmlzyhFMfq1bs2+S/8Z5n4oMekg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  postConfigure = ''
    substituteInPlace setup.py \
      --replace "\"pytest>=2\"," ""
  '';

  buildInputs = [ isl pybind11 ];
  propagatedBuildInputs = [ six ];

  preCheck = "mv islpy islpy.hidden";
  nativeCheckInputs = [ pytestCheckHook ];
  pythonImportsCheck = [ "islpy" ];

  meta = with lib; {
    description = "Python wrapper around isl, an integer set library";
    homepage = "https://github.com/inducer/islpy";
    license = licenses.mit;
<<<<<<< HEAD
    maintainers = [ ];
=======
    maintainers = [ maintainers.costrouc ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}

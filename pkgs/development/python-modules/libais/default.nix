<<<<<<< HEAD
{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
, six
}:

buildPythonPackage rec {
  pname = "libais";
  version = "0.17";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-6yrqIpjF6XaSfXSOTA0B4f3aLcHXkgA/3WBZBBNQ018=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "'pytest-runner'," ""
  '';

  propagatedBuildInputs = [
    six
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # data files missing
  doCheck = false;

  pythonImportsCheck = [
    "ais"
  ];

  meta = with lib; {
    description = "Library for decoding maritime Automatic Identification System messages";
    homepage = "https://github.com/schwehr/libais";
    changelog = "https://github.com/schwehr/libais/blob/master/Changelog.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
=======
{ lib, buildPythonPackage, fetchPypi,
  six, pytest, pytest-runner, pytest-cov, coverage
}:
buildPythonPackage rec {
  pname = "libais";
  version = "0.17";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0pyka09h8nb0vlzh14npq4nxmzg1046lr3klgn97dsf5k0iflapb";
  };

  # data files missing
  doCheck = false;

  nativeCheckInputs = [ pytest pytest-runner pytest-cov coverage ];
  propagatedBuildInputs = [ six ];

  meta = with lib; {
    homepage = "https://github.com/schwehr/libais";
    description = "Library for decoding maritime Automatic Identification System messages";
    license = licenses.asl20;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    platforms = platforms.unix;
  };
}

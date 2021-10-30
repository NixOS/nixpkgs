{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pybind11
, pytestCheckHook
, python-dateutil
, doxygen
, python
, pelican
, matplotlib
}:

buildPythonPackage rec {
  pname = "pytomlpp";
  version = "0.3.5";

  src = fetchFromGitHub {
    owner = "bobfang1992";
    repo = pname;
    rev = version;
    fetchSubmodules = true;
    sha256 = "1h06a2r0f5q4mml485113mn7a7585zmhqsk2p1apcybyydllcqda";
  };

  buildInputs = [ pybind11 ];

  checkInputs = [
    pytestCheckHook

    python-dateutil
    doxygen
    python
    pelican
    matplotlib
  ];

  # pelican requires > 2.7
  doCheck = !pythonOlder "3.6";

  preCheck = ''
    cd tests
  '';

  pythonImportsCheck = [ "pytomlpp" ];

  meta = with lib; {
    description = "A python wrapper for tomlplusplus";
    homepage = "https://github.com/bobfang1992/pytomlpp";
    license = licenses.mit;
    maintainers = with maintainers; [ evils ];
  };
}

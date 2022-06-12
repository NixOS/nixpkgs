{ lib
, buildPythonPackage
, fetchPypi
, python
, mock
, blessings
, nose
, nose_progressive
, pillow
, args
, pkgs
}:

buildPythonPackage rec {
  pname = "clint";
  version = "0.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1an5lkkqk1zha47198p42ji3m94xmzx1a03dn7866m87n4r4q8h5";
  };

  LC_ALL="en_US.UTF-8";

  propagatedBuildInputs = [ pillow blessings args ];

  # nose-progressive and clint are not actively maintained
  # no longer compatible as behavior demand 2to3, which was removed
  # in setuptools>=58
  doCheck  = false;
  checkInputs = [ mock nose nose_progressive pkgs.glibcLocales ];
  checkPhase = ''
    ${python.interpreter} test_clint.py
  '';

  pythonImportsCheck = [ "clint" ];

  meta = with lib; {
    homepage = "https://github.com/kennethreitz/clint";
    description = "Python Command Line Interface Tools";
    license = licenses.isc;
    maintainers = with maintainers; [ domenkozar ];
  };

}

{ stdenv, buildPythonPackage, fetchFromGitHub
, python, pythonPackages, cython
, openems, csxcad, boost
}:

buildPythonPackage rec {
  pname = "python-openems";
  version = "0.0.33";

  src = fetchFromGitHub {
    owner = "thliebig";
    repo = "openEMS";
    rev = "ffcf5ee0a64b2c64be306a3154405b0f13d5fbba";
    sha256 = "1c8wlv0caxlhpicji26k93i9797f1alz6g2kc3fi18id0b0bjgha";
  };

  sourceRoot = "source/python";

  buildInputs = [
    cython
    boost
  ];

  propagatedBuildInputs = [
    openems
    csxcad
    python
    pythonPackages.python-csxcad
    pythonPackages.numpy
    pythonPackages.h5py
  ];

  setupPyBuildFlags = "-I${openems}/include -L${openems}/lib -R${openems}/lib";

  meta = with stdenv.lib; {
    description = "Python interface to OpenEMS";
    homepage = http://openems.de/index.php/Main_Page.html;
    license = licenses.gpl3;
    maintainers = with maintainers; [ matthuszagh ];
    platforms = platforms.linux;
  };
}

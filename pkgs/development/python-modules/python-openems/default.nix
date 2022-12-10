{ lib
, buildPythonPackage
, fetchFromGitHub
, cython
, openems
, csxcad
, boost
, python-csxcad
, numpy
, h5py
}:

buildPythonPackage rec {
  pname = "python-openems";
  version = "unstable-2020-02-15";

  src = fetchFromGitHub {
    owner = "thliebig";
    repo = "openEMS";
    rev = "ba793ac84e2f78f254d6d690bb5a4c626326bbfd";
    sha256 = "1dca6b6ccy771irxzsj075zvpa3dlzv4mjb8xyg9d889dqlgyl45";
  };

  sourceRoot = "source/python";

  nativeBuildInputs = [
    cython
    boost
  ];

  propagatedBuildInputs = [
    openems
    csxcad
    python-csxcad
    numpy
    h5py
  ];

  setupPyBuildFlags = [ "-I${openems}/include" "-L${openems}/lib" "-R${openems}/lib" ];
  pythonImportsCheck = [ "openEMS" ];

  meta = with lib; {
    description = "Python interface to OpenEMS";
    homepage = "http://openems.de/index.php/Main_Page.html";
    license = licenses.gpl3;
    maintainers = with maintainers; [ matthuszagh ];
    platforms = platforms.linux;
  };
}

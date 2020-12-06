{ stdenv
, buildPythonPackage
, fetchPypi
, nose
, cython
, numpy
}:

buildPythonPackage rec {
  version = "0.14.1";
  pname = "hdmedians";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ccefaae26302afd843c941b3b662f1119d5a36dec118077310f811a7a1ed8871";
  };

  # nose was specified in setup.py as a build dependency...
  buildInputs = [ cython nose ];
  propagatedBuildInputs = [ numpy ];

  # cannot resolve path for packages in tests
  doCheck = false;

  checkPhase = ''
    nosetests
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/daleroberts/hdmedians";
    description = "High-dimensional medians";
    license = licenses.gpl3;
    maintainers = [ maintainers.costrouc ];
  };
}

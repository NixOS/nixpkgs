{ stdenv, buildPythonPackage, fetchPypi, EasyProcess, entrypoint2, pathpy
, pillow, pyscreenshot, nose
}:

buildPythonPackage rec {
  pname = "PyVirtualDisplay";
  version = "0.2.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ankzn4d3akm3dkbsl1w988kjgad07lp3brh1kkwn9v75pm073b5";
  };

  propagatedBuildInputs = [ EasyProcess ];
  checkInputs = [ entrypoint2 nose pathpy pillow pyscreenshot ];

  checkPhase = ''
    runHook preCheck
    nosetests -v .
    runHook postCheck
  '';

  meta = with stdenv.lib; {
    description = "Python wrapper for Xvfb, Xephyr and Xvnc";
    homepage = https://github.com/ponty/pyvirtualdisplay;
    license = licenses.bsd2;
    maintainers = with maintainers; [ gerschtli ];
  };
}

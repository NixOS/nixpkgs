{ stdenv, buildPythonPackage, fetchFromGitHub
, python, pythonPackages, cython
, openems, csxcad
}:

buildPythonPackage rec {
  pname = "python-csxcad";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "thliebig";
    repo = "CSXCAD";
    rev = "55899d0fc3dbfc2eb3ec60af9783925926e661a9";
    sha256 = "18h10575c8k0bx7l0pk5ksqfc1vvnsg98br2987y8x4jmrw2jy50";
  };

  sourceRoot = "source/python";

  buildInputs = [
    cython
  ];

  propagatedBuildInputs = [
    openems
    csxcad
    python
    pythonPackages.numpy
    pythonPackages.matplotlib
  ];

  setupPyBuildFlags = "-I${openems}/include -L${openems}/lib -R${openems}/lib";

  meta = with stdenv.lib; {
    description = "Python interface to CSXCAD";
    homepage = http://openems.de/index.php/Main_Page.html;
    license = licenses.gpl3;
    maintainers = with maintainers; [ matthuszagh ];
    platforms = platforms.linux;
  };
}

{ lib
, buildPythonPackage
, fetchFromGitHub
, cython
, openems
, csxcad
, numpy
, matplotlib
}:

buildPythonPackage rec {
  pname = "python-csxcad";
  version = "unstable-2020-02-18";

  src = fetchFromGitHub {
    owner = "thliebig";
    repo = "CSXCAD";
    rev = "ef6e40931dbd80e0959f37c8e9614c437bf7e518";
    sha256 = "072s765jyzpdq8qqysdy0dld17m6sr9zfcs0ip2zk8c4imxaysnb";
  };

  sourceRoot = "source/python";

  nativeBuildInputs = [
    cython
  ];

  propagatedBuildInputs = [
    openems
    csxcad
    numpy
    matplotlib
  ];

  setupPyBuildFlags = "-I${openems}/include -L${openems}/lib -R${openems}/lib";

  meta = with lib; {
    description = "Python interface to CSXCAD";
    homepage = "http://openems.de/index.php/Main_Page.html";
    license = licenses.gpl3;
    maintainers = with maintainers; [ matthuszagh ];
    platforms = platforms.linux;
  };
}

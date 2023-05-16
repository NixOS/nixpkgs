{ lib
, buildPythonPackage
, fetchPypi
, numpy
, python
}:

buildPythonPackage rec {
  pname = "scikit-fmm";
<<<<<<< HEAD
  version = "2023.4.2";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-14ccR/ggdyq6kvJWUe8U5NJ96M45PArjwCqzxuJCPAs=";
=======
  version = "2022.8.15";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-BgDmxoB1QzZ/DlqIB0m66Km+fbAo5RcpjmX0BZ9985w=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    numpy
  ];

  checkPhase = ''
    mkdir testdir; cd testdir
    ${python.interpreter} -c "import skfmm, sys; sys.exit(skfmm.test())"
  '';

  meta = with lib; {
    description = "A Python extension module which implements the fast marching method";
    homepage = "https://github.com/scikit-fmm/scikit-fmm";
    license = licenses.bsd3;
<<<<<<< HEAD
    maintainers = with maintainers; [ ];
=======
    maintainers = with maintainers; [ costrouc ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}

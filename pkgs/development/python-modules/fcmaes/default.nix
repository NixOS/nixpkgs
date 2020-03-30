{ lib
, armadillo
, buildPythonPackage
, cmake
, fetchPypi
, isPy27
, mkl
, pytestCheckHook
, scipy
}:

buildPythonPackage rec {
  pname = "fcmaes";
  version = "0.9.5.7";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1za05afp6x98dmdj61brkkdfzkgv0ixyafp8zh94fa001vs2qrvl";
  };
  
  dontUseCmakeConfigure = true;

  nativeBuildInputs = [
    cmake
  ];

  # Fix the configuration of the internal library:
  #   - unset the C++ compiler (clang++);
  #   - fix the installation path;
  #   - install without sudo (unnessary since the library is installed locally).
  preConfigure = ''
    sed -i '/clang/d' _fcmaescpp/CMakeLists.txt
    sed -i 's!../fcmaes!../fcmaes/lib!' _fcmaescpp/CMakeLists.txt
    sed -i 's/sudo//' _fcmaescpp/install.sh
  '';

  # Build the internal library, using the install script:
  #   - run cmake/make in the _fcmaescpp folder;
  #   - install the built lib to the fcmaes/lib/ folder (as expected by the
  #     python module).
  preBuild = ''
    cd _fcmaescpp
    sh install.sh
    cd ..
  '';

  propagatedBuildInputs = [
    armadillo
    mkl
    scipy
  ];

  checkInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Fast Python implementation of the CMA-ES optimization algorithm";
    homepage = "https://github.com/dietmarwo/fast-cma-es";
    license = licenses.mit;
    maintainers = with maintainers; [ juliendehos ];
  };
}


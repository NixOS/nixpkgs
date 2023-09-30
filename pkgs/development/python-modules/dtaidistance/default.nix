{ lib
, buildPythonPackage
, fetchFromGitHub
, llvmPackages
, pytestCheckHook
, cython
, numpy
}:

buildPythonPackage rec {
  pname = "dtaidistance";
  version = "2.3.10";

  src = fetchFromGitHub {
    owner = "wannesm";
    repo = "dtaidistance";
    rev = "v${version}";
    hash = "sha256-JP/EljFemywgRgspxFzIoHeTtI8gK1SbKgBcGTmzmqw=";
  };

  nativeBuildInputs = [ cython numpy ];

  buildInputs = [ llvmPackages.openmp ];

  propagatedBuildInputs = [ numpy ];

  nativeCheckInputs = [ pytestCheckHook ];
  pytestFlagsArray = [
    "$src/tests"
  ];

  preCheck = ''
    cd $out
  '';

  meta = with lib; {
    homepage = "https://dtaidistance.readthedocs.io";
    description = "Time series distances: Dynamic Time Warping (fast DTW implementation in C)";
    changelog = "https://github.com/wannesm/dtaidistance/releases/tag/${src.rev}";
    license = licenses.asl20;
    maintainers = with maintainers; [ wietsedv ];
  };
}

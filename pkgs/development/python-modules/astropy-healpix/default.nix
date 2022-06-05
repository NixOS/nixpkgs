{ lib
, buildPythonPackage
, fetchPypi
, numpy
, astropy
, astropy-extension-helpers
, setuptools-scm
, pytestCheckHook
, pytest-doctestplus
, hypothesis
}:

buildPythonPackage rec {
  pname = "astropy-healpix";
  version = "0.6";

  src = fetchPypi {
    inherit version;
    pname = lib.replaceStrings ["-"] ["_"] pname;
    sha256 = "409a6621c383641456c074f0f0350a24a4a58e910eaeef14e9bbce3e00ad6690";
  };

  nativeBuildInputs = [
    astropy-extension-helpers
    setuptools-scm
  ];

  propagatedBuildInputs = [
    numpy
    astropy
  ];

  checkInputs = [
    pytestCheckHook
    pytest-doctestplus
    hypothesis
  ];

  # tests must be run in the build directory
  preCheck = ''
    cd build/lib*
  '';

  meta = with lib; {
    description = "BSD-licensed HEALPix for Astropy";
    homepage = "https://github.com/astropy/astropy-healpix";
    license = licenses.bsd3;
    maintainers = [ maintainers.smaret ];
  };
}

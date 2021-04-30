{ lib
, stdenv
, python
, buildPythonPackage
, fetchPypi
, substituteAll
, libjpeg_turbo
, numpy
}:

buildPythonPackage rec {
  pname = "pyturbojpeg";
  version = "1.4.3";

  src = fetchPypi {
    pname = "PyTurboJPEG";
    inherit version;
    sha256 = "sha256-Q7KVfR9kA32QPQFWgSSCVB5sNOmSF8y5J4dmBc14jvg=";
  };

  patches = [
    (substituteAll {
      src = ./lib-path.patch;
      libturbojpeg = "${libjpeg_turbo.out}/lib/libturbojpeg${stdenv.hostPlatform.extensions.sharedLibrary}";
    })
  ];

  propagatedBuildInputs = [
    numpy
  ];

  # upstream has no tests, but we want to test whether the library is found
  checkPhase = ''
    ${python.interpreter} -c 'from turbojpeg import TurboJPEG; TurboJPEG()'
  '';

  pythonImportsCheck = [ "turbojpeg" ];

  meta = with lib; {
    description = "A Python wrapper of libjpeg-turbo for decoding and encoding JPEG image";
    homepage = "https://github.com/lilohuang/PyTurboJPEG";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}

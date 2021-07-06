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
  version = "1.5.1";

  src = fetchPypi {
    pname = "PyTurboJPEG";
    inherit version;
    sha256 = "sha256-56FnJpnQzFPlz0v506CrwIHf9uV3R1LibnuEL7RcFCg=";
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

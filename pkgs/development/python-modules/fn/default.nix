{
  lib,
  buildPythonPackage,
  fetchpatch,
  fetchPypi,
  pythonAtLeast,
}:

buildPythonPackage rec {
  pname = "fn";
  version = "0.4.3";
  format = "setuptools";

  # Python 3.11 changed the API of the `inspect` module and fn was never
  # updated to adapt; last commit was in 2014.
  disabled = pythonAtLeast "3.11";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1nmsjmn8jb4gp22ksx0j0hhdf4y0zm8rjykyy2i6flzimg6q1kgq";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/kachayev/fn.py/commit/a54fc0bd8aeae277de2db726131d249ce607c0c2.patch";
      hash = "sha256-I0ZISOgVibsc1k7gwSfeW6qV9PspQqdaHlRLr/IusQ8=";
      excludes = [ "fn/monad.py" ];
    })
  ];

  meta = with lib; {
    description = ''
      Functional programming in Python: implementation of missing
      features to enjoy FP
    '';
    homepage = "https://github.com/kachayev/fn.py";
    license = licenses.asl20;
  };
}

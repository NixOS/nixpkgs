{ lib, stdenv, python, buildPythonPackage, fetchFromGitHub, fetchpatch
, substituteAll, file, glibcLocales }:

buildPythonPackage rec {
  pname = "python-magic";
  version = "0.4.24";

  src = fetchFromGitHub {
    owner = "ahupp";
    repo = "python-magic";
    rev = version;
    sha256 = "17jalhjbfd600lzfz296m0nvgp6c7vx1mgz82jbzn8hgdzknf4w0";
  };

  patches = [
    # pull upstream patch to support file-5.41
    (fetchpatch {
      name = "file-5.41-compat.patch";
      url =
        "https://github.com/ahupp/python-magic/commit/0ae7e7ceac0e80e03adc75c858bb378c0427331a.patch";
      sha256 = "0vclaamb56nza1mcy88wjbkh81hnish2gzvl8visa2cknhgdmk50";
    })

    (substituteAll {
      src = ./libmagic-path.patch;
      libmagic =
        "${file}/lib/libmagic${stdenv.hostPlatform.extensions.sharedLibrary}";
    })
  ];

  checkInputs = [ glibcLocales ];

  checkPhase = ''
    LC_ALL="en_US.UTF-8" ${python.interpreter} test/test.py
  '';

  meta = with lib; {
    description =
      "A python interface to the libmagic file type identification library";
    homepage = "https://github.com/ahupp/python-magic";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}

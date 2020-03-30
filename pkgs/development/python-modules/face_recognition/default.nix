{ buildPythonPackage, fetchFromGitHub, pillow, click, dlib, numpy
, face_recognition_models, stdenv, flake8, pytest, glibcLocales
}:

buildPythonPackage rec {
  pname = "face_recognition";
  version = "1.3.0";

  src = fetchFromGitHub {
    repo = pname;
    owner = "ageitgey";
    rev = "d34c622bf42e2c619505a4884017051ecf61ac77";
    sha256 = "052878vnh3vbrsvmpgr0bx78k524dlxn47b2xakzbxk7dyjrgcli";
  };

  postPatch = ''
    substituteInPlace setup.py --replace "flake8==2.6.0" "flake8"
  '';

  propagatedBuildInputs = [ pillow click dlib numpy face_recognition_models ];

  # Our dlib is compiled with AVX instructions by default which breaks
  # with "Illegal instruction" on some builders due to missing hardware features.
  #
  # As this makes the build fairly unreliable, it's better to skip the test and to ensure that
  # the build is working and after each change to the package, manual testing should be done.
  doCheck = false;

  # Although tests are disabled by default, checkPhase still exists, so
  # maintainers can check the package's functionality locally before modifying it.
  checkInputs = [ flake8 pytest glibcLocales ];
  checkPhase = ''
    LC_ALL="en_US.UTF-8" py.test
  '';

  meta = with stdenv.lib; {
    license = licenses.mit;
    homepage = https://github.com/ageitgey/face_recognition;
    maintainers = with maintainers; [ ma27 ];
    description = "The world's simplest facial recognition api for Python and the command line";
  };
}

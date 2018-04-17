{ buildPythonPackage, fetchFromGitHub, pillow, click, dlib, numpy
, face_recognition_models, stdenv, flake8, tox, pytest, glibcLocales
}:

buildPythonPackage rec {
  pname = "face_recognition";
  version = "1.2.2";

  src = fetchFromGitHub {
    repo = pname;
    owner = "ageitgey";
    rev = "v${version}";
    sha256 = "17jnyr80j1p74gyvh1jabvwd3zsxvip2y7cjhh2g6gsjv2dpvrjv";
  };

  postPatch = ''
    substituteInPlace setup.py --replace "flake8==2.6.0" "flake8"
  '';

  propagatedBuildInputs = [ pillow click dlib numpy face_recognition_models ];

  checkInputs = [ flake8 tox pytest glibcLocales ];
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

{ stdenv, buildPythonPackage, fetchPypi, pythonOlder, six
, pytest, backports_unittest-mock, keyring, setuptools_scm
}:

buildPythonPackage rec {
  pname = "keyrings.alt";
  version = "3.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0lgp2d3hrpvbb2rfz18vrv5lrck72k3l2f2cpkbks2kigrfbgiqb";
  };

  postPatch = ''
    substituteInPlace pytest.ini \
      --replace "--flake8" ""
  '';

  nativeBuildInputs = [ setuptools_scm ];
  propagatedBuildInputs = [ six ];

  checkInputs = [ pytest keyring ] ++ stdenv.lib.optional (pythonOlder "3.3") backports_unittest-mock;

  checkPhase = ''
    py.test
  '';

  meta = with stdenv.lib; {
    license = licenses.mit;
    description = "Alternate keyring implementations";
    homepage = https://github.com/jaraco/keyrings.alt;
    maintainers = with maintainers; [ nyarly ];
  };
}

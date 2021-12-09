{ lib
, buildPythonPackage
, fetchFromGitHub
, pytest
, six
}:

buildPythonPackage rec {
  pname = "docrep";
  version = "0.3.2";

  src = fetchFromGitHub {
     owner = "Chilipp";
     repo = "docrep";
     rev = "v0.3.2";
     sha256 = "0xcb3wpzy4k5aka3x4wmrn84r9mz2paygcw73rcqgrdi4aa1m65s";
  };

  checkInputs = [ pytest ];
  propagatedBuildInputs = [ six ];

  checkPhase = ''
    py.test
  '';

  # tests not packaged with PyPi download
  doCheck = false;

  meta = {
    description = "Python package for docstring repetition";
    homepage = "https://github.com/Chilipp/docrep";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ costrouc ];
  };
}

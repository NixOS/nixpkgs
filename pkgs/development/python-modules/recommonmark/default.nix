{ lib
, buildPythonPackage
, fetchFromGitHub
, pytest
, CommonMark
, docutils
, sphinx
}:

buildPythonPackage rec {
  pname = "recommonmark";
  version = "0.5.0";

  # PyPI tarball is missing some test files: https://github.com/rtfd/recommonmark/pull/128
  src = fetchFromGitHub {
    owner = "rtfd";
    repo = pname;
    rev = version;
    sha256 = "04bjqx2hczmg7rnj2rpsjk7h24diwk83s6fhgrxk00k40w2bpz5j";
  };

  checkInputs = [ pytest ];
  propagatedBuildInputs = [ CommonMark docutils sphinx ];

  checkPhase = ''
    py.test
  '';

  meta = {
    description = "A docutils-compatibility bridge to CommonMark";
    homepage = https://github.com/rtfd/recommonmark;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fridh ];
  };
}

{ stdenv, buildPythonPackage, fetchFromGitHub
, six, pytest, arrow
}:

buildPythonPackage rec {
  pname   = "construct";
  version = "2.9.45";

  src = fetchFromGitHub {
    owner  = pname;
    repo   = pname;
    rev    = "v${version}";
    sha256 = "0ig66xrzswpkhhmw123p2nvr15a9lxz54a1fmycfdh09327c1d3y";
  };

  propagatedBuildInputs = [ six ];

  checkInputs = [ pytest arrow ];

  # TODO: figure out missing dependencies
  doCheck = false;
  checkPhase = ''
    py.test -k 'not test_numpy and not test_gallery' tests
  '';

  meta = with stdenv.lib; {
    description = "Powerful declarative parser (and builder) for binary data";
    homepage = http://construct.readthedocs.org/;
    license = licenses.mit;
    maintainers = with maintainers; [ bjornfor ];
  };
}

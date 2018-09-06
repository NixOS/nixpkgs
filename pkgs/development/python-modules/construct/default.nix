{ stdenv, buildPythonPackage, fetchFromGitHub, six, pytest }:

buildPythonPackage rec {
  pname = "construct";
  version = "2.8.16";
  name = pname + "-" + version;

  src = fetchFromGitHub {
    owner = "construct";
    repo = "construct";
    rev = "v${version}";
    sha256 = "0lzz1dy419n254qccch7yx4nkpwd0fsyjhnsnaf6ysgwzqxxv63j";
  };

  propagatedBuildInputs = [ six ];

  checkInputs = [ pytest ];

  checkPhase = ''
    py.test -k 'not test_numpy' tests
  '';

  meta = with stdenv.lib; {
    description = "Powerful declarative parser (and builder) for binary data";
    homepage = http://construct.readthedocs.org/;
    license = licenses.mit;
    maintainers = with maintainers; [ bjornfor ];
  };
}

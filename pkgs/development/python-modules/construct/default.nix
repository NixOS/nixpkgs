{ stdenv, buildPythonPackage, fetchFromGitHub, six, pythonOlder }:

buildPythonPackage rec {
  name = "construct-${version}";
  version = "2.8.16";

  src = fetchFromGitHub {
    owner = "construct";
    repo = "construct";
    rev = "v${version}";
    sha256 = "0lzz1dy419n254qccch7yx4nkpwd0fsyjhnsnaf6ysgwzqxxv63j";
  };

  propagatedBuildInputs = [ six ];

  # Tests fail with the following error on Python 3.5+
  # TypeError: not all arguments converted during string formatting
  doCheck = pythonOlder "3.5";

  meta = with stdenv.lib; {
    description = "Powerful declarative parser (and builder) for binary data";
    homepage = http://construct.readthedocs.org/;
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ bjornfor ];
  };
}

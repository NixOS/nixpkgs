{ stdenv, buildPythonPackage, fetchFromGitHub, isPy3k, sphinx, libGLU_combined, libX11, pytest, pycodestyle, numpy }:

buildPythonPackage rec {
  pname = "ModernGL";
  version = "5.2.1";

  src = fetchFromGitHub {
    owner = "cprogrammer1994";
    repo = pname;
    rev = version;
    sha256 = "1ap1b3isvvxbjxr741l6r3m30ki2dj2yqswb33928iawfpamqc4g";
  };

  disabled = !isPy3k;

  propagatedBuildInputs = [ sphinx libGLU_combined libX11 ];
  checkInputs = [ pytest pycodestyle numpy ];

  checkPhase = ''
    py.test
  '';

  meta = with stdenv.lib; {
    description = "ModernGL: High performance rendering for Python 3";
    homepage = https://github.com/cprogrammer1994/ModernGL;
    license = licenses.mit;
    maintainers = with maintainers; [ psyanticy ];
  };

}

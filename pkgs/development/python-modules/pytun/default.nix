{ stdenv
, buildPythonPackage
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "pytun";
  version = "2.2.1";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "montag451";
    repo = "pytun";
    sha256 = "1bxk0z0v8m0b01xg94f039j3bsclkshb7girvjqfzk5whbd2nryh";
  };

  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/montag451/pytun;
    description = "Linux TUN/TAP wrapper for Python";
    license = licenses.mit;
    maintainers = with maintainers; [ montag451 ];
    platforms = platforms.linux;
  };

}

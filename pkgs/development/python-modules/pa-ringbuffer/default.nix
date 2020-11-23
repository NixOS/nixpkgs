{ fetchFromGitHub, buildPythonPackage, lib }:

buildPythonPackage rec {
  pname = "pa-ringbuffer";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "spatialaudio";
    repo = "python-pa-ringbuffer";
    rev = version;
    sha256 = "0afpydy1l20hd1xncjppjhqa2c8dj5h9nlv4z8m55cs9hc9h1mxv";
  };

  meta = {
    description = "Adds ring buffer functionality";
    homepage = "https://github.com/spatialaudio/python-pa-ringbuffer";
    maintainers = with lib.maintainers; [ laikq ];
    license = lib.licenses.mit;
  };
}

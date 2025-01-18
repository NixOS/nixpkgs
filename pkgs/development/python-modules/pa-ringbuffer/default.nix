{
  fetchFromGitHub,
  buildPythonPackage,
  lib,
}:

buildPythonPackage rec {
  pname = "pa-ringbuffer";
  version = "0.1.4";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "spatialaudio";
    repo = "python-pa-ringbuffer";
    rev = version;
    sha256 = "1d4k6z13mc1f88m6wbhfx8hillb7q78n33ws5bmyblsdkv1gx607";
  };

  meta = with lib; {
    description = "Adds ring buffer functionality";
    homepage = "https://github.com/spatialaudio/python-pa-ringbuffer";
    maintainers = with maintainers; [ laikq ];
    license = licenses.mit;
  };
}

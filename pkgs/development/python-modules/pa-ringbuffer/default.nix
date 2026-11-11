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
    hash = "sha256-B5j+wp5N0+XrKpqPYdHBZ1EaIeoOLm4qQi6wOsI3k7Q=";
  };

  meta = {
    description = "Adds ring buffer functionality";
    homepage = "https://github.com/spatialaudio/python-pa-ringbuffer";
    maintainers = with lib.maintainers; [ laikq ];
    license = lib.licenses.mit;
  };
}

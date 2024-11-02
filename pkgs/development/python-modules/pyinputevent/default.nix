{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
}:

buildPythonPackage {
  pname = "pyinputevent";
  version = "2016-10-18";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "ntzrmtthihu777";
    repo = "pyinputevent";
    rev = "d2075fa5db5d8a402735fe788bb33cf9fe272a5b";
    sha256 = "0rkis0xp8f9jc00x7jb9kbvhdla24z1vl30djqa6wy6fx0cr6sib";
  };

  meta = with lib; {
    homepage = "https://github.com/ntzrmtthihu777/pyinputevent";
    description = "Python interface to the Input Subsystem's input_event and uinput";
    license = licenses.bsd3;
    platforms = platforms.unix;
  };
}

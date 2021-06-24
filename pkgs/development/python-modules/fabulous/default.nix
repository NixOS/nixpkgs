{ lib
, buildPythonPackage
, fetchFromGitHub
, pillow
, python
}:

buildPythonPackage rec {
  pname = "fabulous";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "jart";
    repo = pname;
    rev = version;
    sha256 = "0yxdaz6yayp1a57kdb2i8q7kwwdlwy4a3d0lr012h2ji9m89c8q7";
  };

  patches = [
    ./relative_import.patch
  ];

  propagatedBuildInputs = [
    pillow
  ];

  checkPhase = ''
    for i in tests/*.py; do
      ${python.interpreter} $i
    done
  '';

  meta = with lib; {
    description = "Make the output of terminal applications look fabulous";
    homepage = "https://jart.github.io/fabulous";
    license = licenses.asl20;
    maintainers = [ maintainers.symphorien ];
  };
}

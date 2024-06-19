{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pillow,
  python,
}:

buildPythonPackage rec {
  pname = "fabulous";
  version = "0.4.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "jart";
    repo = pname;
    rev = version;
    hash = "sha256-hchlxuB5QP+VxCx+QZ2739/mR5SQmYyE+9kXLKJ2ij4=";
  };

  patches = [ ./relative_import.patch ];

  propagatedBuildInputs = [ pillow ];

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

{ lib, buildPythonPackage, isPyPy, fetchFromGitHub, pythonOlder
, cffi, pycparser, mock, pytest, py, six }:

buildPythonPackage rec {
  version = "3.2.0";
  pname = "bcrypt";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
     owner = "pyca";
     repo = "bcrypt";
     rev = "3.2.0";
     sha256 = "1vb9yx8bqxp2r94jxsckhwzplcn92cic521r76jv0q58kfxx7x8c";
  };

  buildInputs = [ pycparser mock pytest py ];

  propagatedBuildInputs = [ six ] ++ lib.optional (!isPyPy) cffi;

  propagatedNativeBuildInputs = lib.optional (!isPyPy) cffi;

  meta = with lib; {
    maintainers = with maintainers; [ domenkozar ];
    description = "Modern password hashing for your software and your servers";
    license = licenses.asl20;
    homepage = "https://github.com/pyca/bcrypt/";
  };
}

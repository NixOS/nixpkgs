{ lib
, fetchFromGitHub
, buildPythonPackage
, pythonOlder
, cffi
, brotli
}:

buildPythonPackage rec {
  pname = "brotlicffi";
  version = "1.0.9.2";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "python-hyper";
    repo = pname;
    rev = "v${version}";
    sha256 = "0qx7an7772brmx1rbbrqzqnkqqvicc70mx740nl31kzzyv4jjs00";
  };

  buildInputs = [
    brotli
  ];

  propagatedNativeBuildInputs = [
    cffi
  ];

  propagatedBuildInputs = [
    cffi
  ];

  preBuild = ''
    export USE_SHARED_BROTLI=1
  '';

  # Test data is not available, only when using libbrotli git checkout
  doCheck = false;

  pythonImportsCheck = [ "brotlicffi" ];

  meta = with lib; {
    description = "Python CFFI bindings to the Brotli library";
    homepage = "https://github.com/python-hyper/brotlicffi";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}

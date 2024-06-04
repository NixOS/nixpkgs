{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  six,
}:

buildPythonPackage rec {
  pname = "cmsis-svd";
  version = "0.4";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "posborne";
    repo = pname;
    rev = "python-${version}";
    sha256 = "01f2z01gqgx0risqnbrlaqj49fmly30zbwsf7rr465ggnl2c04r0";
  };

  preConfigure = ''
    cd python
  '';

  propagatedBuildInputs = [ six ];

  pythonImportsCheck = [ "cmsis_svd" ];

  meta = with lib; {
    description = "CMSIS SVD parser";
    homepage = "https://github.com/posborne/cmsis-svd";
    maintainers = with maintainers; [ dump_stack ];
    license = licenses.asl20;
  };
}

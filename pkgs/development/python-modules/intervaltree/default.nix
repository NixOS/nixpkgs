{
  lib,
  buildPythonPackage,
  fetchPypi,
  python,
  pytest,
  sortedcontainers,
}:

buildPythonPackage rec {
  version = "3.1.0";
  format = "setuptools";
  pname = "intervaltree";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-kCsbiJNpGPmyoZ4OXrfMtDCuRc3k856ks2kykg0zlS0=";
  };

  buildInputs = [ pytest ];

  propagatedBuildInputs = [ sortedcontainers ];

  checkPhase = ''
    runHook preCheck
    rm build -rf
    ${python.interpreter} nix_run_setup test
    runHook postCheck
  '';

  meta = with lib; {
    description = "Editable interval tree data structure for Python 2 and 3";
    homepage = "https://github.com/chaimleib/intervaltree";
    license = [ licenses.asl20 ];
    maintainers = [ maintainers.bennofs ];
  };
}

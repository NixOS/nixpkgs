{
  lib,
  fetchFromGitHub,
  fetchpatch,
  buildPythonPackage,
  isPy3k,
  flask,
  mock,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "flask-seasurf";
  version = "2.0.0";
  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "maxcountryman";
    repo = "flask-seasurf";
    rev = version;
    hash = "sha256-ajQiDizNaF0em9CVeaHEuJEeSaYraJh9YgvhvBPTIsk=";
  };


  propagatedBuildInputs = [ flask ];

  nativeCheckInputs = [
    unittestCheckHook
    mock
  ];

  pythonImportsCheck = [ "flask_seasurf" ];

  meta = with lib; {
    description = "Flask extension for preventing cross-site request forgery";
    homepage = "https://github.com/maxcountryman/flask-seasurf";
    license = licenses.bsd3;
    maintainers = with maintainers; [ zhaofengli ];
  };
}

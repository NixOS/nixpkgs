{
  lib,
  python,
  fetchFromGitHub,
  buildPythonPackage,
}:
buildPythonPackage {
  pname = "pyppeteer-stealth";
  # https://pypi.org/project/pyppeteer-stealth/#history
  version = "2.7.4";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "MeiK2333";
    repo = "pyppeteer_stealth";
    rev = "0f04fcfbf596052bbbe102d5e68f82956af57338";
    hash = "sha256-/Ja51TicRytMrL3z/kultuQjhlq3m7IHU/CLY3EqdN8=";
  };

  pythonImportsCheck = [ "pyppeteer_stealth" ];

  propagatedBuildInputs = [ python.pkgs.pyppeteer ];

  meta = {
    description = "Pyppeteer stealth";
    homepage = "https://github.com/MeiK2333/pyppeteer_stealth";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ phanirithvij ];
  };
}

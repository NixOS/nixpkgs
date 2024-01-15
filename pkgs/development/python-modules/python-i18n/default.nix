{ lib, buildPythonPackage, fetchFromGitHub, pytestCheckHook, pyyaml }:

buildPythonPackage rec {
  pname = "python-i18n";
  version = "0.3.9";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "danhper";
    repo = pname;
    rev = "v${version}";
    sha256 = "6FahoHZqaOWYGaT9RqLARCm2kLfUIlYuauB6+0eX7jA=";
  };

  nativeCheckInputs = [ pytestCheckHook pyyaml ];

  pytestFlagsArray = [ "i18n/tests/run_tests.py" ];

  meta = with lib; {
    description = "Easy to use i18n library";
    homepage = "https://github.com/danhper/python-i18n";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ emilytrau ];
  };
}

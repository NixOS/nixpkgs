{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  black,
  fetchpatch,
}:

buildPythonPackage rec {
  pname = "black-macchiato";
  version = "1.3.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "wbolster";
    repo = "black-macchiato";
    rev = version;
    sha256 = "0lc9w50nlbmlzj44krk7kxcia202fhybbnwfh77xixlc7vb4rayl";
  };

  patches = [
    # fix empty multi-line string test
    (fetchpatch {
      url = "https://github.com/wbolster/black-macchiato/commit/d3243a1c95b5029b3ffa12417f0c587a2ba79bcd.patch";
      hash = "sha256-3m8U6c+1UCRy/Fkq6lk9LhwrFyE+q3GD2jnMA7N4ZJs=";
    })
  ];

  propagatedBuildInputs = [ black ];

  nativeCheckInputs = [
    pytestCheckHook
    black
  ];

  pythonImportsCheck = [ "black" ];

  meta = {
    description = "This is a small utility built on top of the black Python code formatter to enable formatting of partial files";
    mainProgram = "black-macchiato";
    homepage = "https://github.com/wbolster/black-macchiato";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ jperras ];
  };
}

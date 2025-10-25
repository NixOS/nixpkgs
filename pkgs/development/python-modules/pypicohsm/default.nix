{
  lib,
  python3,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonPackage {
  pname = "pypicohsm";
  version = "unstable-2024-06-19";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "polhenarejos";
    repo = "pypicohsm";
    rev = "83cb202aa73ec3c8aab45e2c5abcd42e4582bd39";
    hash = "sha256-glx0O70B+5UcMbjuK5MOHj2hPn9kqOP2v3pXPvXIIco=";
  };

  propagatedBuildInputs = (
    with python3.pkgs;
    [
      cryptography
      base58
      pyusb
      pyscard
      pycvc
    ]
  );

  pythonImportsCheck = [ "picohsm" ];

  meta = {
    description = "Pico HSM client for Python";
    homepage = "https://github.com/polhenarejos/pypicohsm.git";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ oluceps ];
  };
}

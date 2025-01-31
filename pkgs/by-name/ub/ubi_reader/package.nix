{
  fetchFromGitHub,
  lib,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "ubi_reader";
  version = "0.8.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "onekey-sec";
    repo = "ubi_reader";
    rev = "v${version}";
    hash = "sha256-04HwzkonPzzWfX8VE//fMoVv5ggAS+61zx2W8VEUIy4=";
  };

  build-system = [ python3.pkgs.poetry-core ];

  dependencies = [ python3.pkgs.lzallright ];

  # There are no tests in the source
  doCheck = false;

  meta = {
    description = "Python scripts capable of extracting and analyzing the contents of UBI and UBIFS images";
    homepage = "https://github.com/onekey-sec/ubi_reader";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ vlaci ];
  };
}

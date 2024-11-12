{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
  pname = "ubi_reader";
  version = "0.8.5";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "jrspruitt";
    repo = pname;
    rev = "v${version}-master";
    hash = "sha256-tjQs1F9kcFrC9FDkfdnax0C8O8Bg7blkpL7GU56eeWU=";
  };

  propagatedBuildInputs = with python3.pkgs; [ python-lzo ];

  # There are no tests in the source
  doCheck = false;

  meta = with lib; {
    description = "Collection of Python scripts for reading information about and extracting data from UBI and UBIFS images";
    homepage = "https://github.com/jrspruitt/ubi_reader";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ vlaci ];
  };
}

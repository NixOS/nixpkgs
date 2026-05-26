{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
}:

buildPythonPackage rec {
  pname = "exfat-raw";
  version = "0.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "MBanucu";
    repo = "exfat-raw";
    rev = "v${version}";
    hash = "sha256-nmWMmU6GNnb2vi9ebC0brpCfyFdBICdAraOqhspesng=";
  };

  nativeBuildInputs = [ setuptools ];

  meta = with lib; {
    description = "Raw block-level read/write of exFAT filesystem timestamps (birth time, modification time)";
    homepage = "https://github.com/MBanucu/exfat-raw";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ mbanucu ];
  };
}

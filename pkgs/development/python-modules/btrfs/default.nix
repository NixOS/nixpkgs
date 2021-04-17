{ lib
, buildPythonPackage
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "btrfs";
  version = "12";

  src = fetchFromGitHub {
    owner = "knorrie";
    repo = "python-btrfs";
    rev = "v${version}";
    sha256 = "sha256-ZQSp+pbHABgBTrCwC2YsUUXAf/StP4ny7MEhBgCRqgE=";
  };

  # no tests (in v12)
  doCheck = false;
  pythonImportsCheck = [ "btrfs" ];

  meta = with lib; {
    description = "Inspect btrfs filesystems";
    homepage = "https://github.com/knorrie/python-btrfs";
    license = licenses.lgpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.evils ];
  };
}

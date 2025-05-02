{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "btrfs";
  version = "13";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-NSyzhpHYDkunuU104XnbVCcVRNDoVBz4KuJRrE7WMO0=";
  };

  # no tests (in v12)
  doCheck = false;
  pythonImportsCheck = [ "btrfs" ];

  meta = with lib; {
    description = "Inspect btrfs filesystems";
    homepage = "https://github.com/knorrie/python-btrfs";
    license = licenses.lgpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ evils Luflosi ];
  };
}

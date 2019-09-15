{ lib, python37Packages  }:

python37Packages.buildPythonPackage rec {
  pname = "pyocclient";
  version = "0.4";

  src = python37Packages.fetchPypi {
    inherit pname version;
    sha256 = "19k3slrk2idixsdw61in9a3jxglvkigkn5kvwl37lj8hrwr4yq6q";
  };

  doCheck = false;

  propagatedBuildInputs = with python37Packages; [
    requests
    six
    ];

  meta = with lib; {
    homepage = https://github.com/owncloud/pyocclient/;
    description = "Nextcloud / Owncloud library for python";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };

}

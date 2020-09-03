{ lib
, buildPythonPackage
, fetchPypi
, fetchurl
, pbr
, six

, reno
, tox
}:
let
  pbr_5_5_0 = pbr.overrideAttrs (old: {
    version = "5.5.0";
    name = "pbr-5.5.0";
    src = fetchPypi {
      pname = "pbr";
      version = "5.5.0";
      sha256 = "1sl2w7zq33kzbh6im3lyl7jfwyddjkqmrx0y5b93v2n7a67xkgql";
    };
  });
in
buildPythonPackage rec {
  pname = "os-service-types";
  version = "1.7.0";

  upper-constraints = fetchurl {
    url = "https://opendev.org/openstack/requirements/raw/branch/master/upper-constraints.txt";
    sha256 = "0l46zy9vrkgycyfc0s9lqscvcaad07bl2lzw3gnq99i61brx4wg0";
  };

  src = fetchPypi {
    inherit pname version;
    sha256 = "0v4chwr5jykkvkv4w7iaaic7gb06j6ziw7xrjlwkcf92m2ch501i";
  };

  patches = [ ./tox-pass-system-pythonpath.patch ];

  propagatedBuildInputs = [
    pbr
    six
  ];
  checkInputs = [
    pbr_5_5_0
    reno
    tox
  ];

  checkPhase = ''
    export UPPER_CONSTRAINTS_FILE="${upper-constraints}"
    tox
  '';

  # Circular dependencies on oslotest, see https://bugs.launchpad.net/oslo.config/+bug/1893978
  doCheck = false;

  meta = with lib; {
    description = "Python library for consuming OpenStack sevice-types-authority data";
    license = licenses.asl20;
    longDescription = ''
      The data is in JSON and the latest data should always be used. This
      simple library exists to allow for easy consumption of the data, along
      with a built-in version of the data to use in case network access is for
      some reason not possible and local caching of the fetched data.
    '';
    maintainers = with maintainers; [ shamilton ];
    platforms = platforms.linux;
  };
}

{ lib, buildPythonApplication, fetchPypi, requests, six, pbr, setuptools }:

buildPythonApplication rec {
  pname = "python-swiftclient";
  version = "3.12.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-MTtEShTQ+bYoy/PoxS8sQnFlj56KM9QiKFHC5PD3t6A=";
  };

  nativeBuildInputs = [ pbr ];

  propagatedBuildInputs = [ requests six setuptools ];

  # For the tests the following requirements are needed:
  # https://github.com/openstack/python-swiftclient/blob/master/test-requirements.txt
  #
  # The ones missing in nixpkgs (currently) are:
  # - hacking
  # - keystoneauth
  # - oslosphinx
  # - stestr
  # - reno
  # - openstackdocstheme
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/openstack/python-swiftclient";
    description = "Python bindings to the OpenStack Object Storage API";
    license = licenses.asl20;
    maintainers = with maintainers; [ c0deaddict SuperSandro2000 ];
  };
}
